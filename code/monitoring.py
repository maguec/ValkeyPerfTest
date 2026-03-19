import os
import time
import redis
from redis.cluster import RedisCluster


def monitor_valkey_disruptions():
    # Configuration
    host = os.getenv("GOOGLE_VALKEY_IP")
    port = int(os.getenv("GOOGLE_VALKEY_PORT") or 6379)
    num_keys = int(os.getenv("KEY_COUNT", 10))

    if not host:
        print("Error: GOOGLE_VALKEY_IP environment variable not set.")
        return

    print(f"Targeting Valkey cluster at {host}:{port}...")

    rc = None
    last_was_success = True

    try:
        while True:
            try:
                # Attempt to create the client if it doesn't exist
                if rc is None:
                    rc = RedisCluster(
                        host=host,
                        port=port,
                        decode_responses=True,
                        skip_full_coverage_check=True,
                        socket_timeout=0.5,
                        socket_connect_timeout=0.5,
                    )

                # Execute the tight loop of writes
                for i in range(num_keys):
                    rc.incrby(f"KEY:{i}", 1)

                # If we reach here, communication worked
                if not last_was_success:
                    print(
                        f"[{time.strftime('%H:%M:%S')}] RECOVERED: Connection restored."
                    )
                    last_was_success = True

            except Exception as e:
                # Catching ALL exceptions here (ConnectionRefused, Timeout, ClusterDown, etc.)
                if last_was_success:
                    # Log the specific error message for debugging
                    error_msg = str(e).split("\n")[0]  # Get the first line of the error
                    print(
                        f"[{time.strftime('%H:%M:%S')}] DISRUPTION DETECTED: {type(e).__name__} - {error_msg}"
                    )
                    last_was_success = False

                # Explicitly kill the client object so it forces a fresh
                # handshake/discovery on the next iteration.
                rc = None

            # 100ms interval
            time.sleep(0.1)

    except KeyboardInterrupt:
        print("\nMonitoring stopped by user.")


if __name__ == "__main__":
    monitor_valkey_disruptions()
