terraform init
terraform apply -auto-approve

BUCKET_NAME=$(terraform output -raw bucket_name)
BUCKET_URL=$(terraform output -raw bucket_url)

aws s3 cp index.html s3://$BUCKET_NAME --profile ada

echo "O seu website está disponível na url: $BUCKET_URL"
