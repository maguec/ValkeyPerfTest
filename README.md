# Valkey Performance Test

Spin up Valkey and Redis clusters so that we can run the performance tests and compare results.

## Usage

### Create a variables file
```bash
cp tfvars.example tester.tfvars
```

### Initialize and apply
```bash
terraform init
terraform apply -var-file tester.tfvars
```

### ssh into the testing machine

Follow the output command like
```bash
ssh -i ~/.ssh/valkey-key tester@<ip-address>
```

### Destroy
```bash
terraform destroy
```

### Let's do some benchmarking
```bash
memtier_benchmark --host ${GOOGLE_REDIS_IP} --hide-histogram --cluster-mode --threads 10 --clients 50 --ratio=1:5 --pipeline=5 --test-time=120
memtier_benchmark --host ${GOOGLE_VALKEY_IP} --hide-histogram --cluster-mode --threads 10 --clients 50 --ratio=1:5 --pipeline=5 --test-time=120
```


### Let's find the max
```bash
for threads in 10 11 12 13 14 15 16; do
    for pipeline in 1 3 5 10; do
        memtier_benchmark --host ${GOOGLE_REDIS_IP} --hide-histogram --cluster-mode --threads ${threads} \
            --clients 50 --ratio=1:5 --pipeline=${pipeline} --test-time=300 --json-out-file=REDIS_${threads}_50_${pipeline}.json
        memtier_benchmark --host ${GOOGLE_VALKEY_IP} --hide-histogram --cluster-mode --threads ${threads} \
            --clients 50 --ratio=1:5 --pipeline=${pipeline} --test-time=300 --json-out-file=VALKEY8_${threads}_50_${pipeline}.json
    done
done
```

