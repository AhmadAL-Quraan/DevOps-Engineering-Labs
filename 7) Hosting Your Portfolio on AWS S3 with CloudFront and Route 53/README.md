
[[#Solution]]








## Brief Summary

This project deploys a personal portfolio on AWS by hosting static files in a private S3 bucket, delivering them securely via CloudFront with Origin Access Control (OAC), and mapping a custom domain using Route 53.

The website uses `index.html` as the entry point and results in a fast, secure, and professional web presence.



## Assignment Details

### 1. Prepare Your Portfolio on AWS by hosting static files in a private S3 bucket, delivering them securely via CloudFront wit

- Build your personal website using HTML/CSS

(or use a free portfolio template) 

- Ensure the main entry point of the website is:

`index.html` 

- Suggested free templates:
    - [https://themewagon.com/theme-tag/portfolio-template/](https://themewagon.com/theme-tag/portfolio-template/)

---

### 2. Create an S3 Bucket

- Create an S3 bucket with a unique name, for example:index.html￼￼ 

`portfolio.yourname.com` 

- Disable all public access to the bucket 
- Upload all portfolio files (HTML, CSS, JS, images)

---

### 3. Create a CloudFront Distribution

- Set the S3 bucket as the origin 
- Use Origin Access Control (OAC) to keep the bucket private 
- Configure the Default Root Object as:

`index.html`

dy6vwh8t8hli9.cloudfront.`

---

### 4. Create a Route 53 Record Set

- Create a Hosted Zone for your domain (if it does not already exist) 
- Add a DNS record that points your custom domain to the CloudFront distribution hosting your portfolio


Record name: ahmadquraan
Record TYpe: CNAME

Make certifications:17bbfb5bfe5ff40e2bb9df65cb0e97c8.ahmadquraan.htufolio.com.




















