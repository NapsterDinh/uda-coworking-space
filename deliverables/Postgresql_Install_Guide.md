- Before you start, ensure you are connected to your K8s cluster
```bash
kubectl get namespace
```
- Create PersistentVolumeClaim, PersistentVolume and deploy it to cluster
```bash
cd ./deployment
kubectl apply -f pvc.yaml
kubectl apply -f pv.yaml
kubectl apply -f postgresql-deployment.yaml
```
- View the pods to get postgresql pod name
```bash
kubectl get pods
```
- Assuming the postgres pod name is `postgresql-5c89cdb65-w2tsf`, run the following command to open bash into the pod.
```bash
kubectl exec -it postgresql-5c89cdb65-w2tsf -- bash
```
- Once you are inside the pod, you can run
```bash
psql -U tsu-user -d tsu-coworking-db
```
- Use `\l` to list out all database and `\c tsu-coworking-db` to access to specific database
- Create pogresql service, secret and expose it using port-forwarding approach:
```bash
kubectl apply -f postgresql-service.yaml
kubectl apply -f postgresql-secret.yaml 
```
- List service and set up port-forwarding to `postgresql-service`
```bash
# List the services
kubectl get svc

# The command above opens up port forwarding from your local environment's port 5433 to the node's port 5432. The & at the end ensures the process runs in the background.
kubectl port-forward svc/postgresql-service 5433:5432 &
```
- Run seed files (make sure you already install `psql`)
```bash
cd ./db
export DB_PASSWORD=123456
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U tsu-user -d tsu-coworking-db -p 5433 < 1_create_tables.sql
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U tsu-user -d tsu-coworking-db -p 5433 < 2_seed_users.sql
PGPASSWORD="$DB_PASSWORD" psql --host 127.0.0.1 -U tsu-user -d tsu-coworking-db -p 5433 < 3_seed_tokens.sql
psql --host 127.0.0.1 -U tsu-user -d tsu-coworking-db -p 5433
```
- Execute query `select *from users`for to ensure they not empty

- NOTE: When you finish project, you must close forward port
```bash
ps aux | grep 'kubectl port-forward' | grep -v grep | awk '{print $2}' | xargs -r kill
```
