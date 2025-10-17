# Runbook: High CPU Throttling on Service B

**Owner:** Service B Team
**Last Updated:** 2025-10-07

This runbook is triggered when a Dynatrace alert fires for high response times on **Service A**, and the root cause is identified as high CPU throttling on its downstream dependency, **Service B**.

---

### 1. Triage

**Goal:** Confirm the issue is active.

The on-call SRE has been paged. The Dynatrace problem ticket indicates that the service-level objective (SLO) for latency on **Service A** has been breached.

---

### 2. Diagnosis

**Goal:** Verify that CPU throttling is the root cause.

The Dynatrace PurePath trace points to **Service B** as the source of the latency. Check the pod's CPU throttling metrics.

1.  **Get the pod name for Service B:**
    ```sh
    kubectl get pods -l app=service-b
    ```

2.  **View the pod's logs in Dynatrace or your logging tool.** Look for any application-level errors.

3.  **Check for CPU throttling in Dynatrace's Workload view.** The "CPU Throttling" metric for the `service-b` deployment will be high. This confirms the pod is being starved of CPU.

---

### 3. Remediation

**Goal:** Mitigate the issue by increasing the pod's CPU limit.

The service has been deployed with an overly restrictive CPU limit. We will apply a new manifest that allocates more CPU resources.

1.  **Apply the remediated Kubernetes manifest:**
    ```sh
    kubectl apply -f k8s/service-b-remediated.yaml
    ```
    This triggers a rolling update of the deployment, replacing the throttled pod with a correctly-provisioned one.

---

### 4. Validation

**Goal:** Confirm that the service has recovered.

1.  **Monitor the rolling update:**
    ```sh
    kubectl rollout status deployment/service-b
    ```

2.  **Check Dynatrace:** The response time for **Service A** and **Service B** should be dropping back to the baseline. CPU throttling on the `service-b` workload will fall to zero.

3.  The incident is now considered mitigated.

