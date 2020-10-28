# BMAT Music Innovators



# App Details
.......
................................................
................................

The app consist of:

    └──

    └──

    └──

    └──

    └──


# Proposed Stack

HCL 


# Top-level directory layout

    📦bmat-devops-task
        📦docs
            ┣ 📜Back_Office DevOps_Test_v2.pdf
            ┣ 📜Back_office_architecture.png
        📦live
            ┣ 📦prod
            ┣ 📦qa
            ┣ 📦stage
        📦modules
            ┣ 📦cache
            ┣ 📦network
            ┣ 📦services
        ┣ 📜README.md


## The task can be found [here](https://github.com/adefemi171/bmat-devops-task/blob/main/docs/Back_Office%20DevOps_Test_v2.pdf)

## Infrastructure Architecture
![](docs/Back_office_architecture.png?raw=true)


## Assumptions
I assumed that the metric I will be using to scale up the number of workers is the CPUUtilization and also I assumed the threshold as the number of job in queues.

1. For cost I used t2.micro instance type and also if there are no pending job in the queue, the instance is scaled down to zero

2. For reusability I have three environment which for further use case will contain different resources based onthe environment been used.

3. For security, I am using state locking and also each environment is been isolated from the other.


# How to setup project

### Clone the repository 

```
git clone https://github.com/adefemi171/bmat-devops-task.git
```
### Checking Out
The infrastructure is build on the ``` main ``` branch you will need to checkout to the app branch using:

```
git checkout main
```

