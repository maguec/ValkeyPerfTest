#!/usr/bin/env python3

import glob
import json
from tabulate import tabulate

results = {
    "REDIS": {},
    "VALKEY8": {},
    "VALKEY9": {},
}

for f in glob.glob("*.json"):
    run_info = f.split(".")[0].split("_")
    with open(f) as j:
        data = json.load(j)
        # results[run_info[0]][f"{run_info[1]:0>2}_{run_info[3]:0>2}"] = data[ "ALL STATS" ]["Totals"]["Percentile Latencies"]["p99.00"]
        results[run_info[0]][f"{run_info[1]:0>2}_{run_info[3]:0>2}"] = data[
            "ALL STATS"
        ]["Totals"]["Ops/sec"]

headers = ["threads", "pipeline", "REDIS", "VALKEY8"]
data = []

params = list(results["VALKEY8"].keys())
params.sort()
for i in params:
    p = [int(num) for num in i.split("_")]
    data.append(
        [
            p[0],
            p[1],
            # results["REDIS"][i],
            # results["VALKEY8"][i],
            # results["VALKEY9"][i],
            "{:,}".format(int(results["REDIS"][i])),
            "{:,}".format(int(results["VALKEY8"][i])),
            "{:,}".format(int(results["VALKEY9"][i])),
        ]
    )

print(tabulate(data, headers=headers, tablefmt="fancy_grid"))
