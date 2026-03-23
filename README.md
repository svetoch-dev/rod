# rod

An attempt to build a cost-efficient, easy-to-manage, easy-to-extend infrastructure with low technical debt that supports multiple clouds.

Rod name derives from "род", a Russian word meaning lineage.

## Problem we are solving

Server software comes in many forms and serves many different purposes, but all server software needs the same basic foundation:

* Hardware to run on
* A way to understand what is happening now and what happened in the past
* A development lifecycle for delivering changes (`develop -> test -> deploy -> repeat`)

The combination of systems that fulfills these needs is called `infrastructure`.

Key aspects of good `infrastructure` are:

1. **Reliability**. The system should operate predictably and continue working even when parts of it fail. This includes high availability, fault tolerance, backups, disaster recovery, and graceful failure.
2. **Observability**. At any point in time, you should be able to understand what is happening in the system and what has happened before.
3. **Scalability**. The infrastructure should support growth without requiring a redesign every few months. This includes scaling traffic, data, teams, and the number of services.
4. **Simplicity**. Simple infrastructure is easier to understand, operate, debug, and hand over to new team members. Complexity is one of the biggest long-term costs in IT.
5. **Maintainability**. Good infrastructure should be easy to change safely. Clear structure, automation, documentation, standard patterns, and low operational burden are essential.
6. **Security**. Security should be built in from the start, not added later. Access control, network isolation, secret management, patching, auditing, and secure defaults are all critical.

Because infrastructure `needs` are fundamentally the same across most server software, we can create an `infrastructure` template that:
* **includes the key properties of good infrastructure**
* **can be reused for any kind of server software**

## This project is for

1. People who need infrastructure to test their idea, but do not want to spend endless hours managing or redesigning it when they grow from 10 daily active users (DAU) to 500,000.
2. People that need cost-efficient infrastructure
3. People that want to move fast without introducing technical debt

## Infrastructure costs

Aproximate infrastructure costs for various clouds:

### GCP

* internal and production  environments in separate clusters (best isolation) [~306$/month](https://cloud.google.com/products/calculator?dl=CjhDaVF5TVRJNVlqUTVOUzA0TXpnekxUUTJNRFV0T1RSbE15MDJNbVZtT0Rka01tWXhOVFVRQVE9PRAOGiRGMTg4QzczQi1GNUQ5LTQzNDgtOTU2NC0wRkY4REZEREY3OTY)
* internal and production  environments in single cluster [~187$/month](https://cloud.google.com/products/calculator?dl=CjhDaVJoWXpFM1lqQmtZeTA1WmprMExUUXdPVFF0T1dObVppMDNOVEZpTWprMU5HRmpNVGdRQVE9PRAPGiQyMDc1MThFQS0yQjIwLTRGMEYtQUI5NC1BOUMwQTAxQzFGMzU)
* internal, development and production  environments in separate clusters [~490$/month](https://cloud.google.com/products/calculator?dl=CjhDaVEyTXpKa05qTXhNUzFqWm1NeUxUUmtZamN0WWprMU9TMHpPV1UxTWpnM056RTBZelVRQVE9PRAOGiRGMTg4QzczQi1GNUQ5LTQzNDgtOTU2NC0wRkY4REZEREY3OTY)

### YC

TBD

## Cost efficiency vs cheapness

Cheap infrastructure is not the same as cost-efficient infrastructure.

Systems optimized purely for low upfront cost often become more expensive over time.

**Example:**
- Running everything (backend, database, etc.) on a single virtual machine using Docker Compose.

This setup is cheap initially, but not cost-efficient because:
- **High operational burden** — manual maintenance, limited automation, harder debugging and recovery
- **Lack of scalability** — the system cannot grow without a redesign
- **Migration cost** — eventually, you will need to invest time and effort to move to a more scalable architecture

---

### What is cost efficiency?

Cost efficiency is not about minimizing spend at a single point in time.
It is about how your **total infrastructure cost per business entity (e.g., per user)** behaves as the system grows.

**Example:**

- At the start:
  - 50 billable users
  - Infrastructure cost: 15,000 RUB
  - Operations cost: 10,000 RUB
  - Cost per user: (15,000 + 10,000) / 50 = **500 RUB**

- Later:
  - 500 billable users
  - Infrastructure cost: 25,000 RUB
  - Operations cost: 10,000 RUB
  - Cost per user: (25,000 + 10,000) / 500 = **70 RUB**

Even though total costs increased, **cost per user decreased significantly**.

---

### Summary

> Cheap solutions minimize cost today.  
> Cost-efficient solutions minimize cost over time.



## State of the project
its still in a WIP(work in progress) state


## Prerequisites
Before doing anything please follow this steps
1. Install pre-commit `pip install pre-commit`
2. Clone this project
3. Run `pre-commit install` from the project dir

### Bazel
Some parts of this repo are managed by [bazel](https://github.com/bazelbuild/bazel) so you need to

* Install [bazelisk](https://github.com/bazelbuild/bazelisk) by
  * Downloading the binary
  * renaming it to `bazel`
  * Adding it to your `PATH`
