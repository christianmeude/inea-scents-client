# Research: Scheduled Cleanup Tasks on Render Free Tier + Supabase

This document outlines the viable free-tier approaches for running a 15-minute scheduled cleanup task on a Laravel backend hosted on Render, using Supabase as the database.

## Constraints & Challenges

1. **Render Native Cron Jobs are Paid:** Render does not offer a free tier for its native Cron Job or Background Worker services. (Source: [Render Cron Jobs Docs](https://render.com/docs/cronjobs))
2. **Render Free Tier Spin-Down:** Render Free web services automatically spin down (go to sleep) after 15 minutes of inactivity. They also have a strict limit of 750 free instance hours per month. (Source: [Render Free Tier Docs](https://render.com/docs/free))
3. **Queue Workers:** Running a continuous queue worker (`php artisan queue:work`) requires a background worker process, which is also a paid feature. 

Because of these constraints, the standard `php artisan schedule:run` system cron is not possible for free. The business logic must be exposed via a secured HTTP endpoint (e.g., `/api/system/cleanup`) and triggered externally. The cleanup must run synchronously within the HTTP request lifecycle.

---

## Option 1: Third-Party Web Cron (e.g., cron-job.org)

**How it works:** 
You create a route in Laravel that executes the cleanup logic. You configure [cron-job.org](https://cron-job.org) (a free external service) to send an HTTP GET or POST request to this URL every 15 minutes.

**Pros:**
*   Completely free and simple to configure.
*   The 15-minute ping effectively acts as a "keep-alive," preventing your Render instance from spinning down.

**Cons:**
*   Keeping the Render instance awake 24/7 will consume approximately 730-744 hours per month. The Render free tier provides exactly 750 free instance hours across *all* services. If you have any other free services on Render, you will exhaust your free hours before the month ends, causing the service to be suspended.
*   Requires securing the endpoint (e.g., a hardcoded secret token in the request header) to prevent malicious triggers.

---

## Option 2: Supabase `pg_cron` + `pg_net`

**How it works:** 
Since you are already using Supabase, you can leverage PostgreSQL extensions. `pg_cron` schedules background jobs within Postgres, and `pg_net` allows Postgres to make asynchronous HTTP requests to your Laravel application.

**Setup Example (Run in Supabase SQL Editor):**
```sql
-- Enable required extensions
create extension if not exists pg_cron;
create extension if not exists pg_net;

-- Schedule the HTTP request to Laravel
select cron.schedule(
  'laravel-cleanup-job', 
  '*/15 * * * *', 
  $$
  select net.http_post(
    url := 'https://your-render-app.onrender.com/api/system/cleanup',
    headers := '{"Authorization": "Bearer YOUR_SECRET_TOKEN"}'::jsonb
  );
  $$
);
```
(Sources: [Supabase pg_cron](https://supabase.com/docs/guides/database/extensions/pg_cron), [Supabase pg_net](https://supabase.com/docs/guides/database/extensions/pg_net))

**Pros:**
*   No need to rely on a third-party tool like cron-job.org.
*   The schedule is natively managed in your database, while the business logic safely resides in Laravel.

**Cons:**
*   Like Option 1, pinging Render every 15 minutes will consume almost all of your 750 free instance hours.
*   **Supabase Free Tier Limits:** Supabase automatically pauses free projects after 1 week of inactivity (defined as no external API requests or Dashboard visits). Internal `pg_cron` executions *do not* count as project activity. (Source: [Supabase Free Tier](https://supabase.com/docs/guides/platform/free-tier))
*   `pg_net` requests are "fire-and-forget". If your Render service is asleep, the cold start might take up to 30 seconds. Postgres will not automatically retry the request if the cold start times out.

---

## Option 3: Internal Request via User Activity

**How it works:** 
Instead of a strict 15-minute clock, you trigger the cleanup logic probabilistically or whenever a user hits a specific API route, similar to how Laravel's native session garbage collection works.

**Pros:**
*   Does not artificially keep the Render service awake, saving free instance hours.
*   Avoids reliance on external schedulers.

**Cons:**
*   Task execution is not guaranteed at exact 15-minute intervals. If there is no traffic, the cleanup does not run.
*   May add slight latency to whichever user request randomly triggers the cleanup.

---

## Recommendation

If you must have guaranteed 15-minute execution and this is your only Render service, **Option 1 (cron-job.org)** or **Option 2 (Supabase pg_cron + pg_net)** are your best choices. **Option 2** is cleaner as it keeps your stack consolidated, provided your app gets enough natural traffic to prevent Supabase from auto-pausing. 

Ensure your Laravel endpoint is secured with a token and that the cleanup script can finish before the Render HTTP timeout (100 seconds).
