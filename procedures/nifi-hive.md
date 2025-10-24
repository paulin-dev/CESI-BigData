# NiFi Hive Integration Guide (via JDBC)

## 1. Set Up DBCPConnectionPool Controller

1. In the **NiFi UI**, **right-click on the canvas** → select **Controller Services**

2. Click the "**+**" icon (top-right)

3. Search for **`DBCPConnectionPool`** and click **Add**

4. In the list, click the **three dots (⋮)** next to the newly created controller → select **Edit**.

5. In the **Properties** tab, fill in:

   | Property                        | Value                                                           |
   | ------------------------------- | --------------------------------------------------------------- |
   | **Database Connection URL**     | `jdbc:hive2://hiveserver2:10000/default`                        |
   | **Database Driver Class Name**  | `org.apache.hive.jdbc.HiveDriver`                               |
   | **Database Driver Location(s)** | `/opt/nifi/nifi-current/lib/ext/hive-jdbc-4.1.0-standalone.jar` |
   | **Database User**               | `hive`                                                          |

6. Click **Apply**

7. Back in the list, click the **three dots (⋮)** → **Enable**

8. In the popup:

   * Select **Service and referencing components**
   * Click **Enable**, then **Close**


## 2. Run a Hive Query

1. Drag an **ExecuteSQL** processor onto the canvas

2. **Right-click** → **Configure → Properties** tab:

   - **Database Connection Pooling Service:** select the `DBCPConnectionPool` controller created earlier
   - **SQL Query:**

     ```sql
     SELECT * FROM my_table LIMIT 5
     ```

3. Click **Apply**
