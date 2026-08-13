# MonEquip Data Warehousing
This is a major assignment stemmed from the course FIT3003 - Business intelligence and data warehousing. The project takes the operational database of a fictitious equipment company, **Monash Equipment Centre (MonEquip)**, and designs a data warehouse to support fast, repeatable business reporting.

## Aims
-  Understanding current operational database of a fictitious company named Monash Equipment Centre (also known as MonEquip) and draw an E/R diagram.
-  Design a data warehouse using Star/Snowflake Schema at different level of aggregation based on business requirement.
-  Explore and perform data cleaning using SQL.

## Business Requirements
MonEquip has two main business functions: selling equipment with after-sales service and providing equipment for hire.
Management regularly generates reports to track revenue and business trends. Because the operational database is large and staff have limited database experience, the goal is a purpose-built data warehouse that makes these reports quick to produce.

**The management of this fictitious company are looking to generate regular reports of these information:**
- Total Sales Revenue for Sales/Equipment Hiring
- Average hire/sales price and revenue
- Number of equipment sold and number of equipment hired

**based on these attributes:**

| Dimension | Detail |
|---|---|
| **Time** | Month / Year |
| **Season** | Australian seasons — Summer, Autumn, Winter, Spring |
| **Customer Type** | Individual / Business |
| **Company Branch** | Branch location (e.g. Clayton, Richmond, Geelong) |
| **Category** | Equipment category (e.g. Vehicles, Lighting, Trailers) |
| **Price Scale** | Low `< $5,000` · Medium `$5,000–$10,000` · High `> $10,000` |

## Warehouse Design
 
The warehouse uses a **multi-fact star schema**, with separate fact tables for the two business functions (hire and sales) sharing common dimensions.
 
Two versions were produced at different levels of granularity:
 
| Version | Aggregation level |
|---|---|
| **Version 1** | High aggregation (summarised by dimension keys) |
| **Version 2** | No aggregation (Level 0 — one row per transaction) |

## Repository Contents

| File | Description |
|---|---|
| `diagram/ERD.png` | E/R diagram of the MonEquip operational database |
| `diagram/StarSchemaV1.png` | Star schema diagram — Version 1 (high aggregation) |
| `diagram/StarSchemaV2.png` | Star schema diagram — Version 2 (no aggregation, Level 0) |
| `DataCleaning.sql` | SQL to explore the operational database and clean the data |
| `Star_Schema_V1.sql` | SQL to build the Version 1 (high-aggregation) star schema |
| `Star_Schema_V2.sql` | SQL to build the Version 2 (Level 0) star schema |
 
## Tech and Knowledge Applied
 
- **Oracle SQL** - schema design and ETL
- Star / snowflake dimensional modelling


 

