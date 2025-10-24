# NiFi PostgreSQL Integration Guide (via JDBC)

## 1. Set Up DBCPConnectionPool Controller

1. In the **NiFi UI**, **right-click on the canvas** → select **Controller Services**

2. Click the "**+**" icon (top-right)

3. Search for **`DBCPConnectionPool`** and click **Add**

4. In the list, click the **three dots (⋮)** next to the newly created controller → select **Edit**.

5. In the **Properties** tab, fill in:

   | Property                        | Value                                                           |
   | ------------------------------- | --------------------------------------------------------------- |
   | **Database Connection URL**     | `jdbc:postgresql://host.docker.internal:5432/postgres`          |
   | **Database Driver Class Name**  | `org.postgresql.Driver`                                         |
   | **Database Driver Location(s)** | `/opt/nifi/nifi-current/lib/ext/postgresql-42.2.9.jar`         |
   | **Database User**               | `postgres`                                                      |
   | **Password**                    | `2025`                                                          |

6. Click **Apply**

7. Back in the list, click the **three dots (⋮)** → **Enable**

8. In the popup:

   * Select **Service and referencing components**
   * Click **Enable**, then **Close**

---

## 2. Run a PostgreSQL Query

1. Drag an **ExecuteSQL** processor onto the canvas

2. **Right-click** → **Configure → Properties** tab:

   - **Database Connection Pooling Service:** select the `DBCPConnectionPool` controller created earlier
   - **SQL Query:**

     ```sql
     SELECT "Id_patient", "Sexe", "Age"
     FROM public."Patient"
     LIMIT 5;
     ```

3. Click **Apply**

4. Connect the **success** and **failure** relationships to a processor like **LogAttribute** or **PutFile** to inspect the results.

---

### Notes

- PostgreSQL is **case-sensitive**: use quotes (`"`) around table and column names if they were created with mixed case.
- Make sure the **driver jar is readable** by NiFi (`chmod 644` and `chown nifi:nifi`).
- `host.docker.internal` allows NiFi Docker to reach PostgreSQL running on your Windows host.
- For ETL workflows, after `ExecuteSQL` you can connect **ConvertRecord → PutHiveQL** to load data into Hive.