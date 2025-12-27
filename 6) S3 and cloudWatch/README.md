



##   Task 1: Identify and Create an S3 BucketIdentify and Create an S3 Bucket

Begin by confirming that no existing bucket will be reused.df

You must create a new, globally unique S3 bucket that follows AWS naming conventions.

Requirements:

- The bucket must be created in a specific AWS region.
- The bucket name must follow AWS naming rules.
- Public access must remain blocked initially.

---

##   Task 2: Upload and Verify Objects

Upload multiple objects (files) into your S3 bucket.

At least one object must be:

- An image file.
- A text or HTML(named index.html) file .

Verify that:

- Each object appears correctly in the S3 console.
- The object key structure reflects proper logical organization.

---

##   Task 3: Enable and Validate Versioning

Enable S3 Versioning at the bucket level.

You must then:

- Upload more than one version of the same file.
- Confirm that multiple versions exist.
- Demonstrate the ability to restore a previous version.

---

##   Task 4: Configure Static Website Hosting

Configure your S3 bucket to act as a static website host.

Your setup must include:

- A valid `index.html` file. 
- Public read access ONLY for website objects.
- Verification that the website loads successfully from the browser.

---

##   Task 5: Implement Lifecycle Management

Create an S3 Lifecycle Rule that performs the following:

- Automatically moves objects to a lower-cost storage class after a defined period.
- Automatically deletes objects after a longer retention period.

---

#   Part 2: Amazon CloudWatch Monitoring & Logging

---

##   Task 6: Explore and Analyze CloudWatch Metrics

Using CloudWatch Metrics, identify and analyze at least:

- One S3 metric.

You must:

- Record the namespace and dimensions used.
- Explain what each metric represents operationally.

---

##   Task 7: Build a CloudWatch Alarm

Create a CloudWatch Alarm that:

- Monitors a performance-related metric.
- Automatically triggers when a defined threshold is exceeded.
- Sends a notification using Amazon SNS. z

The alarm must transition properly between:

- OK
- ALARM
- INSUFFICIENT_DATA

---