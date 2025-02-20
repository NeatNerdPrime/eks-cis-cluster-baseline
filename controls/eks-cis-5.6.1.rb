control 'eks-cis-5.6.1' do
  title 'Consider Fargate for running untrusted workloads'
  desc  'It is Best Practice to restrict or fence untrusted workloads when running in a multi-tenant
  environment.'
  desc 'rationale', "AWS Fargate is a technology that provides on-demand, right-sized compute capacity for
containers. With AWS Fargate, you no longer have to provision, configure, or scale groups
of virtual machines to run containers. This removes the need to choose server types, decide
when to scale your node groups, or optimize cluster packing.

    You can control which pods start on Fargate and how they run with Fargate profiles, which
are defined as part of your Amazon EKS cluster.

    Amazon EKS integrates Kubernetes with AWS Fargate by using controllers that are built by
AWS using the upstream, extensible model provided by Kubernetes. These controllers run
as part of the Amazon EKS managed Kubernetes control plane and are responsible for
scheduling native Kubernetes pods onto Fargate. The Fargate controllers include a new
scheduler that runs alongside the default Kubernetes scheduler in addition to several
mutating and validating admission controllers. When you start a pod that meets the criteria
for running on Fargate, the Fargate controllers running in the cluster recognize, update,
and schedule the pod onto Fargate.

    Each pod running on Fargate has its own isolation boundary and does not share the
underlying kernel, CPU resources, memory resources, or elastic network interface with
another pod.
  "
  desc 'check', "
    Check the existence of Fargate profiles in the Amazon EKS cluster by using:
    ```
    aws --region ${AWS_REGION} eks list-fargate-profiles --cluster-name
    ${CLUSTER_NAME}
    ```
    Alternatively, to audit for the presence of a Fargate profile node run the following
  command:
    ```
    kubectl get nodes
    ```
    The response should include a NAME entry starting with \"fargate-ip\"
  for example:
    ```
    NAME STATUS ROLES AGE VERSION
    fargate-ip-192-168-104-74.us-east-2.compute.internal Ready 2m15s v1.14.8-eks
    ```
    "
  desc 'fix', "
    Create a Fargate profile for your cluster
    Before you can schedule pods running on Fargate in your cluster, you must define a Fargate
profile that specifies which pods should use Fargate when they are launched. For more
information, see AWS Fargate profile.
    Note
    If you created your cluster with eksctl using the --fargate option, then a Fargate profile has
already been created for your cluster with selectors for all pods in the kube-system and
default namespaces. Use the following procedure to create Fargate profiles for any other
namespaces you would like to use with Fargate.
    via eksctl CLI
    Create your Fargate profile with the following eksctl command, replacing the variable text
with your own values. You must specify a namespace, but the labels option is not required.
    ```
    eksctl create fargateprofile --cluster cluster_name --name
    fargate_profile_name --namespace kubernetes_namespace --labels key=value
    ```
    via AWS Management Console
    To create a Fargate profile for a cluster with the AWS Management Console
1. Open the Amazon EKS console at
https://console.aws.amazon.com/eks/home#/clusters.
2. Choose the cluster to create a Fargate profile for.
3. Under Fargate profiles, choose Add Fargate profile.
4. On the Configure Fargate profile page, enter the following information and choose
Next.
• For Name, enter a unique name for your Fargate profile.
• For Pod execution role, choose the pod execution role to use with your Fargate
profile. Only IAM roles with the eks-fargate-pods.amazonaws.com service principal
are shown. If you do not see any roles listed here, you must create one. For more
information, see Pod execution role.
• For Subnets, choose the subnets to use for your pods. By default, all subnets in your
cluster's VPC are selected. Only private subnets are supported for pods running on
Fargate; you must deselect any public subnets.
• For Tags, you can optionally tag your Fargate profile. These tags do not propagate to
other resources associated with the profile, such as its pods.
5. On the Configure pods selection page, enter the following information and choose
Next.
• list text hereFor Namespace, enter a namespace to match for pods, such as kubesystem
or default.
• list text here(Optional) Add Kubernetes labels to the selector that pods in the
specified namespace must have to match the selector. For example, you could add
the label infrastructure: fargate to the selector so that only pods in the specified
namespace that also have the infrastructure: fargate Kubernetes label match the
selector.
6. On the Review and create page, review the information for your Fargate profile and
choose Create.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: nil
  tag gid: nil
  tag rid: nil
  tag stig_id: nil
  tag fix_id: nil
  tag cci: nil
  tag nist: ['AC-6']
  tag cis_level: 1
  tag cis_controls: [
    { '7' => ['18.9'] }
  ]
  tag cis_rid: '5.6.1'

  describe 'Manual control' do
    skip 'Manual review is required to determine if the cluster requires a Fargate profile for untrusted workloads'
  end
end
