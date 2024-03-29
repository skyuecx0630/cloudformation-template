#!/bin/bash -eux
yum update -y

# install codedeploy-agent
yum install ruby wget -y

wget -O /tmp/install https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x /tmp/install
/tmp/install auto

# install amazon-cloudwatch-agent and its config
yum install -y amazon-cloudwatch-agent

cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/opt/app/app.log",
            "log_group_name": "/aws/ec2/myapp",
            "log_stream_name": "api_{instance_id}",
            "timezone": "Local"
          }
        ]
      }
    }
  }
}
EOF

# enable daemons
systemctl enable codedeploy-agent --now
systemctl enable amazon-cloudwatch-agent --now