# VeriGlobe QDI – Quality Data Interface

## Overview
The **Quality Data Interface (QDI)** is a **cloud-hosted platform** developed for **VeriGlobe Solutions Ltd.** to streamline **quality testing and inspection reporting**.  
It enables **clients, test labs, and factories** to upload Excel/CSV test results, which are automatically transformed into **interactive dashboards, defect analyses, and compliance reports**.

---

## Tech Stack
- **Frontend**: Vue.js (component-based UI, form validation, dashboards)  
- **Backend/API**: Node.js (Express) REST services with JSON payloads  
- **Database**: PostgreSQL on AWS RDS (relational schema, validation queries, reporting views)  
- **Cloud Hosting**: AWS Elastic Beanstalk (apps), S3 (file storage), Route 53 (DNS)  
- **Integrations**: AWS SES (email notifications), CloudWatch (logging & monitoring), Cognito (authentication & RBAC)  
- **Reporting/Analytics**: Exportable reports (Excel/PDF), defect summaries, compliance scorecards, capability metrics  

---

## Features
- **File-driven data pipeline**  
  Upload Excel/CSV test results → validate → normalize → load into relational schema  

- **Interactive dashboards**  
  Real-time defect counts, pass/fail trends, compliance scoring  

- **Automated reporting**  
  Generate parameterized defect & compliance reports (Excel/PDF export)  

- **Inspection workflows**  
  Audit trails with client/lab/factory role-based access  

- **Cloud deployment**  
  Hosted on AWS with secure authentication and monitoring  

---

## Screenshots

### Dashboard – Testing Overview
<img width="645" height="697" alt="qa_desktop_dash" src="https://github.com/user-attachments/assets/7bdb7cce-58a0-448b-9ab4-94f0245c6e3e" />



### Defect Analysis
<img width="770" height="917" alt="qa_desktop_examples" src="https://github.com/user-attachments/assets/2bae28be-5082-4aa0-bc96-4599ba917159" />



### Compliance Reporting
<img width="774" height="832" alt="qa_desktop_examples2" src="https://github.com/user-attachments/assets/0e48d364-5e75-4eab-a8a3-93792f05952a" />



---

## Summary
QDI consolidates quality test data into a **single cloud platform**, reducing manual effort, improving accuracy, and delivering **real-time visibility** across the testing and inspection lifecycle.
