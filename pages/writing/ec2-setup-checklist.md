---

title: Checklist for EC2 Base Setup
published: true
date: 2021-02-18T13:46:39.029Z
---

<label><input type="checkbox" class="task-item list-style-none" />Create an ec2 instance (obviously,you braindamaged alien) </label>
<label><input type="checkbox" class="task-item list-style-none" />Enable SSH (random port) and HTTP 80 on the instance.</label>
<label><input type="checkbox" class="task-item list-style-none" />Increase the ssd/EBS size to a min of (20/40) Gigs</label>
<label><input type="checkbox" class="task-item list-style-none" />Add a swap file to the system</label>
<label><input type="checkbox" class="task-item list-style-none" />Install dokku</label>
<label><input type="checkbox" class="task-item list-style-none" />Write a script for the dokku process for the current app (or use [dokcli](https://github.com/barelyhuman/dokcli), if you're completed it)</label>
<label><input type="checkbox" class="task-item list-style-none" />Create a Dynamic Floating IP</label>
<label><input type="checkbox" class="task-item list-style-none" />Map needed domains to Floating IP</label>
<label><input type="checkbox" class="task-item list-style-none" />Get Repo, configure Repo to deploy to dokku </label>
<label><input type="checkbox" class="task-item list-style-none" />Refill Cup of Coffee.</label>

## Document DB Checklist

Note: VPC Constrained - Won't work for public access

<label><input type="checkbox" class="task-item list-style-none" />Create Cluster.</label>
<label><input type="checkbox" class="task-item list-style-none" />Make it public via security groups .</label>
<label><input type="checkbox" class="task-item list-style-none" />Disable TLS if needed .</label>
<label><input type="checkbox" class="task-item list-style-none" />Restart the cluster.</label>
