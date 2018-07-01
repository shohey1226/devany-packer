[Packer] is the tool to build images. Using packer, you can create devany image.

```
# create Docker image 
$ packer build -only=docker devany.json

# create Amazon EC2 image
$ REGION=ap-northeast-1 AWS_ACCESS_KEY=xxx AWS_SECRET_KEY=yyy packer build -only=ami devany.json

# create Google image
$ REGION=asia-northeast1-a GOOGLE_ACCOUNT_FILE=zzz packer build -only=google devany.json

# create lxd image
$ packer build -only=lxd devany.json
```

## References

* AWS Regiion: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
* Google zone: https://cloud.google.com/compute/docs/regions-zones/regions-zones
* Create google account file: https://www.packer.io/docs/builders/googlecompute.html#running-without-a-compute-engine-service-account  
