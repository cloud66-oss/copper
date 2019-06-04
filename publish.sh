#!/bin/bash

aws s3 cp build s3://downloads.cloud66.com/copper --acl public-read --recursive
