```
# create Amazon EC2 image
$ AWS_ACCESS_KEY=xxx AWS_SECRET_KEY=yyy packer build -only=ami devany.json

# create lxd image
$ packer build -only=lxd devany.json
```

## References

* AWS Regiion: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
* Google zone: https://cloud.google.com/compute/docs/regions-zones/regions-zones
