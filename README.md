<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

# Geodesic [![Build Status](https://travis-ci.org/nikiai/geodesic.svg?branch=master)](https://travis-ci.org/nikiai/geodesic) [![Latest Release](https://img.shields.io/github/release/nikiai/geodesic.svg)](https://github.com/nikiai/geodesic/releases/latest) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


![Geodesic](docs/geodesic-small.png)

Geodesic is the fastest way to get up and running with a rock solid, production grade cloud platform built entirely from Open Source technologies. 

It’s a swiss army knife for creating and building consistent platforms to be shared across a team environment.

It easily versions staging environments in a repeatable manner that can be followed by any team member.

It's a way of doing things that allows companies to collaborate on infrastructure (~snowflakes~) and radically reduce Total Cost of Ownership, along with a vibrant and active [slack community](https://slack.cloudposse.com).

It provides a fully customizable framework for defining and building cloud infrastructures backed by [AWS](https://aws.amazon.com/) and powered by [kubernetes](https://kubernetes.io/). It couples best-of-breed technologies with engineering best-practices to equip organizations with the tooling that enables clusters to be spun up in record time without compromising security. 

It's works with Mac OSX, Linux, and [Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10). 


---

This project is part of our comprehensive ["SweetOps"](https://docs.cloudposse.com) approach towards DevOps. 


It's 100% Open Source and licensed under the [APACHE2](LICENSE).









## Introduction

These days, the typical software application is distributed as a docker image and run as a container. Why should infrastructure be any different? Since everything we write is "Infrastructure as Code", we believe that it should be treated the same way. This is the "Geodesic Way". Use containers+envs instead of unconventional wrappers, complicated folder structures and symlink hacks. Geodesic is the container for all your infrastructure automation needs that enables you to truly achieve SweetOps.

Geodesic is composed of two parts:

  1. It is an interactive command-line shell. The shell includes the *ultimate* mashup of cloud orchestration tools. Those tools are then integrated to work in concert with each other using a consistent framework. Installation of the shell is as easy as running a docker container.  
  2. It is a distribution of essential services and [reference architectures](https://github.com/cloudposse?q=cloudposse.co). The distribution includes a collection of [100+ Free Terraform Modules](https://github.com/cloudposse?q=terraform-) and their [invocations](https://github.com/cloudposse/terraform-root-modules), dozens of preconfigured [Helmfiles](https://github.com/cloudposse/helmfiles), [Helm charts](https://github.com/cloudposse/charts) for CI/CD, VPN, SSH Bastion, Automatic DNS, Automatic TLS, Automatic Monitoring, Account Management, Log Collection, Load Balancing/Routing, Image Serving, and much more. What makes these charts even more valuable is that they were designed from the ground up to work well with each other and integrate with external services for authentication (SSO/OAuth2, MFA).

An organization may chose to leverage all of these components, or just the parts that make their life easier.

Let's roll...

Review our [documentation](https://docs.cloudposse.com/geodesic/) and [reference architectures](https://docs.cloudposse.com/reference-architectures/) to get started!







## Features

* **Secure** - TLS/PKI, OAuth2, MFA Everywhere, remote access VPN, [ultra secure bastion/jumphost](https://github.com/cloudposse/bastion) with audit capabilities and slack notifications, [IAM assumed roles](https://github.com/99designs/aws-vault/), automatic key rotation, encryption at rest, and VPCs
* **Repeatable** - 100% Infrastructure-as-Code with change automation and support for scriptable admin tasks in any language, including Terraform
* **Extensible** - A framework where everything can be extended to work the way you want to
* **Comprehensive** - our [helm charts library](https://github.com/cloudposse/charts) are designed to tightly integrate your cloud-platform with Github Teams and Slack Notifications and CI/CD systems like TravisCI, CircleCI or Jenkins
* **OpenSource** - Permissive [APACHE 2.0](LICENSE) license means no lock-in and no on-going license fees

## Technologies

At its core, Geodesic is a framework for provisioning cloud infrastructure and the applications that sit on top of it. We leverage as many existing tools as possible to facilitate cloud fabrication and administration. We're like the connective tissue that sits between all of the components of a modern cloud.

* [`ansible`](http://docs.ansible.com/ansible/latest/index.html) Ansible is an IT automation tool. It can configure systems, deploy software, and orchestrate more advanced IT tasks
* [`aws-vault`](https://github.com/99designs/aws-vault) for securely storing and accessing AWS credentials in an encrypted vault for the purpose of assuming IAM roles
* [`aws-cli`](https://github.com/aws/aws-cli/) for interacting directly with the AWS APIs
* [`chamber`](https://github.com/segmentio/chamber) for managing secrets with AWS SSM+KMS and exposing them as environment variables
* [`helm`](https://github.com/kubernetes/helm/) for installing packages like Varnish or Apache on the Kubernetes cluster
* [`helmfile`](https://github.com/roboll/helmfile) for 12-factorizing chart values and installing chart collections
* [`kops`](https://github.com/kubernetes/kops/) for Kubernetes cluster orchestration
* [`kubectl`](https://kubernetes.io/docs/user-guide/kubectl-overview/) for controlling kubernetes resources like deployments or load balancers
* [`gcloud`, `gsutil`](https://cloud.google.com/sdk/) for integration with Google Cloud (e.g. GKE, GCE, Google Storage)
* [`gomplate`](https://github.com/hairyhenderson/gomplate/) for template rendering configuration files using the GoLang template engine. Supports lots of local and remote datasources
* [`goofys`](https://github.com/kahing/goofys/) a high-performance Amazon S3 file system for mounting encrypted S3 buckets that store cluster configurations and secrets
* [`terraform`](https://github.com/hashicorp/terraform/) for provisioning miscellaneous resources on pretty much any cloud

[](https://media.giphy.com/media/26FmS6BRnPVPo2FDq/source.gif)

## Documentation

Extensive documentation is provided on our [Documentation Hub](https://docs.cloudposse.com/geodesic). 
## Our Logo

![Geodesic Logo](docs/geodesic-small.png)

In mathematics, a geodesic line is the shortest distance between two points on a sphere. It's also a solid structure composed of geometric shapes such as hexagons.

We like to think of geodesic as the shortest path to a rock-solid cloud infrastructure. The geodesic logo is a hexagon with a cube suspended at its center. The cube represents this geodesic container, which is central to everything and at the same time is what ties everything together.

But look a little closer and you’ll notice there’s much more to it. It's also an isometric shape of a cube with a missing piece. This represents its pluggable design, which lets anyone extend it to suit their vision.




## Related Projects

Check out these related projects.

- [Packages](https://github.com/cloudposse/packages) - Cloud Posse installer and distribution of native apps
- [Build Harness](https://github.com/cloudposse/dev) - Collection of Makefiles to facilitate building Golang projects, Dockerfiles, Helm charts, and more
- [terraform-root-modules](https://github.com/cloudposse/terraform-root-modules) - Collection of Terraform "root module" invocations for provisioning reference architectures
- [root.cloudposse.co](https://github.com/cloudposse/root.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Parent ("Root") Organization in AWS.
- [audit.cloudposse.co](https://github.com/cloudposse/audit.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for an Audit Logs Organization in AWS.
- [prod.cloudposse.co](https://github.com/cloudposse/prod.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Production Organization in AWS.
- [staging.cloudposse.co](https://github.com/cloudposse/staging.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Staging Organization in AWS.
- [dev.cloudposse.co](https://github.com/cloudposse/dev.cloudposse.co) - Example Terraform Reference Architecture of a Geodesic Module for a Development Sandbox Organization in AWS.



## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/geodesic/issues), send us an [email][email] or join our [Slack Community][slack].

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [*commercial support*][commercial_support] for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time engineer. 

[![E-Mail](https://img.shields.io/badge/email-hello@cloudposse.com-blue.svg)](mailto:hello@cloudposse.com)

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll develop original modules to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands-on support to implement our reference architectures. 


## Community Forum

Get access to our [Open Source Community Forum][slack] on Slack. It's **FREE** to join for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build *sweet* infrastructure.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/geodesic/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://github.com/orgs/cloudposse/projects/3) with our other projects, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!


## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)



## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.









## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

[![Cloud Posse](https://cloudposse.com/logo-300x69.svg)](https://cloudposse.com)

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We love [Open Source Software](https://github.com/cloudposse/)!

We offer paid support on all of our projects.  

Check out [our other projects][github], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.

  [docs]: https://docs.cloudposse.com/
  [website]: https://cloudposse.com/
  [github]: https://github.com/cloudposse/
  [commercial_support]: https://github.com/orgs/cloudposse/projects
  [jobs]: https://cloudposse.com/jobs/
  [hire]: https://cloudposse.com/contact/
  [slack]: https://slack.cloudposse.com/
  [linkedin]: https://www.linkedin.com/company/cloudposse
  [twitter]: https://twitter.com/cloudposse/
  [email]: mailto:hello@cloudposse.com


### Contributors

|  [![Erik Osterman][osterman_avatar]][osterman_homepage]<br/>[Erik Osterman][osterman_homepage] | [![Igor Rodionov][goruha_avatar]][goruha_homepage]<br/>[Igor Rodionov][goruha_homepage] | [![Andriy Knysh][aknysh_avatar]][aknysh_homepage]<br/>[Andriy Knysh][aknysh_homepage] | [![Sarkis Varozian][sarkis_avatar]][sarkis_homepage]<br/>[Sarkis Varozian][sarkis_homepage] |
|---|---|---|---|


  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144


  [goruha_homepage]: https://github.com/goruha/
  [goruha_avatar]: http://s.gravatar.com/avatar/bc70834d32ed4517568a1feb0b9be7e2?s=144


  [aknysh_homepage]: https://github.com/aknysh/
  [aknysh_avatar]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144


  [sarkis_homepage]: https://github.com/sarkis
  [sarkis_avatar]: https://avatars3.githubusercontent.com/u/42673?s=144&v=4



