EC2 Pricing Options
On-Demand Instances
Definition: Pay for compute capacity by the hour or second with no long-term commitments.
Use Case: Ideal for short-term, irregular workloads that cannot be interrupted.
Benefits:
Flexibility to scale up or down.
No upfront costs or long-term contracts.
Spot Instances
Definition: Purchase unused EC2 capacity at discounted rates, up to 90% off On-Demand prices.
Use Case: Suitable for flexible, stateless, or fault-tolerant applications.
Benefits:
Cost savings for workloads that can tolerate interruptions.
Great for batch processing, big data, and CI/CD workloads.
Reserved Instances (RIs)
Definition: Commit to using EC2 for a 1 or 3-year term in exchange for a significant discount on the hourly rate.
Use Case: Best for steady-state or predictable usage.
Benefits:
Up to 75% discount compared to On-Demand.
Options for All Upfront, Partial Upfront, or No Upfront payment.
Standard RIs can be modified or sold on the Reserved Instance Marketplace.
Savings Plans
Definition: Flexible pricing model offering significant savings over On-Demand pricing, in exchange for a commitment to a consistent amount of usage (measured in $/hour) for a 1 or 3-year term.
Use Case: Ideal for customers looking for the most flexibility and maximum savings.
Benefits:
Up to 72% savings compared to On-Demand.
Automatically apply to any usage across AWS services (compute services).
Two types: Compute Savings Plans (flexible across any region) and EC2 Instance Savings Plans (specific to instance family in a region).

===
### EC2 Instance Types - Brief Bullet Points

1. **General Purpose**
    - **Balanced resources**: Suitable for a wide range of workloads.
    - **Examples**:
        - `t3` and `t3a` (burstable performance)
        - `m5` and `m6g` (general purpose)
2. **Compute Optimized**
    - **High compute-to-memory ratio**: Ideal for compute-bound applications.
    - **Examples**:
        - `c5` and `c6g` (high performance)
        - `c5n` (high network bandwidth)
3. **Memory Optimized**
    - **High memory-to-compute ratio**: Suitable for memory-intensive applications.
    - **Examples**:
        - `r5` and `r6g` (memory intensive)
        - `x1` and `x2gd` (extremely high memory)
4. **Storage Optimized**
    - **High, fast storage**: Ideal for workloads that require high IOPS.
    - **Examples**:
        - `i3` and `i3en` (high IOPS storage)
        - `d2` and `d3` (dense storage)
5. **Accelerated Computing**
    - **Hardware accelerators**: GPU, FPGA, or inference chips for high-performance computing.
    - **Examples**:
        - `p3` and `p4` (GPU optimized)
        - `f1` (FPGA-based)



====
## Amazon Machine Image (AMI)

- **Definition**:
    - AMI stands for Amazon Machine Image.
    - Customization of an EC2 instance.
- **Benefits**:
    - Custom software configuration.
    - Pre-configured operating system and monitoring.
    - Faster boot configuration time due to pre-packaged software.
- **Regional Specificity**:
    - AMI is built for a specific region.
    - Can be copied across regions.


===
## **AWS Instance Store :**

- **Volume Type**:
    - Instance store volumes are from the same hardware as the EC2 instance. EBS and EFS are network drives
    - High-performance hard disk.
- **Ephemeral Data**:
    - Data is ephemeral; lost when instance is stopped or terminated.
- **Limitations**:
    - Cannot increase or decrease data.
    - Cannot change storage type.

## **AWS EBS :**

- **Availability Zone Specific**:
    - EBS volumes are specific to an AZ.
    - To move to another AZ  create a snapshot(point in time) and create volume in that AZ using snapshot.
    - To move to another Region  create a snapshot and copy snapshot to another region and create volume in that Region using snapshot.
- **Attachment Flexibility**:
    - Attach/detach EBS volumes from running instances.
    - Can reattach to any instance within the same AZ.
- **Network Drive**:
    - EBS is a network-attached storage, leading to potential latency.
- **EBS Optimization Support**:
    - EBS storage optimization provides a dedicated network path.
- **Attachment Limits**:
    - Standard EBS volume: One EC2 instance.
    - IO1 and IO2 volumes: Up to 16 EC2 instances in the same AZ.
- **Mounting and Formatting**:
    - After attaching, mount and format the volume on the EC2 instance.
- **Multiple Volumes**:
    - EC2 instances can use multiple EBS volumes.
- **Resize Limitations**:
    - EBS volumes can only be increased in size.
- **Deletion on termination**:
    - EBS Root volumes by default deleted on ec2 termination. Disable delete on termination to retain root volume.
    - Other attached volumes are by default retained.

## **EBS Volume Types**:

- **SSD Types**:
    1. General Purpose (gp2, gp3)
    2. Provisioned IOPS (io1, io2)
    3. io2 Block Express
- **HDD Types**:
    1. Throughput Optimized (st1)
    2. Cold HDD (sc1)

**EBS Volume Characteristics**:

- **Size**: Ranges from 1 GB to 64 TB.
- **Throughput or IOPS**: Varies by volume type.

## General Purpose SSD (gp2, gp3)

- **Use Cases**: System boot volumes, virtual desktops, development and testing environments.
- **gp3**:
    - Baseline: 3,000 IOPS, 125 MB/s throughput.
    - Max: 16,000 IOPS, 1,000 MB/s throughput (independent scaling).
- **gp2**:
    - IOPS linked to volume size.
    - Max: 16,000 IOPS.
    - Burst: Small volumes can burst up to 3,000 IOPS.

### Provisioned IOPS SSD (io1, io2)

- **Use Cases**: Critical business applications, database workloads sensitive to storage performance.
- **Capacity**: 4 GB to 64 TB.
- **Max IOPS**:
    - Nitro EC2 instances: 64,000 IOPS.
    - Other instances: 32,000 IOPS.
- **Features**:
    - Can independently increase IOPS from storage size.
    - io1 and io2 support EBS Multi-Attach (up to 16 instances).

### HDD Types

**Throughput Optimized HDD (st1)**:

- **Use Cases**: Big data, data warehousing, log processing.
- **Max Throughput**: 500 MB/s.
- **Max IOPS**: 500.

**Cold HDD (sc1)**:

- **Use Cases**: Infrequently accessed data, cost-sensitive scenarios.
- **Max Throughput**: 250 MB/s.
- **Max IOPS**: 250.

=====
## **Amazon EBS Snapshots**

- **Definition**: Point-in-time copies of data on Amazon EBS volumes, known as snapshots.
- **Incremental Backup**:
    - Saves only the blocks that have changed since the most recent snapshot.
    - Minimizes snapshot creation time.
    - Reduces storage costs by avoiding data duplication.
- **Storage**:
    - Stored in Amazon S3, in buckets not directly accessible.
    - Not accessible via Amazon S3 console or S3 API.
- **Cost**:
    - Based on the amount of data stored.
    - Incremental nature means deleting a snapshot might not immediately reduce storage costs.
    - Data exclusive to a snapshot is removed upon deletion, while data shared with other






