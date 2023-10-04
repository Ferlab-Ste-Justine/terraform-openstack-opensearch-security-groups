# About

This is a terraform module that provisions security groups meant to be restrict network access to an opensearch cluster.

The following security group is created:
- **member**: Security group for members of the opensearch cluster. It can make external requests and communicate with other members of the **member** group on ports **9200** and **9300**

Additionally, you can pass a list of groups that will fulfill each of the following roles:
- **bastion**: Security groups that will have access to the opensearch servers on port **22** as well as icmp traffic.
- **client**: Security groups that will have access to the opensearch servers on ports **9200** and **5601** as well as icmp traffic.
- **metrics_server**: Security groups that will have access to the opensearch servers on ports **9200** and **9100** as well as icmp traffic.

# Usage

## Variables

The module takes the following variables as input:

- **member_group_name**: Name to give to the security group for the opensearch members
- **client_group_ids**: List of ids of security groups that should have **client** access to the opensearch cluster
- **bastion_group_ids**: List of ids of security groups that should have **bastion** access to the opensearch cluster
- **metrics_server_group_ids**: List of ids of security groups that should have **metrics server** access to the opensearch cluster.
- **fluentd_security_group**: Optional fluentd security group configuration. It has the following keys:
  - **id**: Id of pre-existing security group to add fluentd rules to
  - **ports**: List of ports the remote fluentd node listens on

## Output

The module outputs the following variables as output:

- **member_group**: Security group for the opensearch members that got created. It contains a resource of type **openstack_networking_secgroup_v2**