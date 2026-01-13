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
