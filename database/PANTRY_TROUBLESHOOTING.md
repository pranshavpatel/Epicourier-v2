# Pantry Database Issue - Troubleshooting Guide

## Problem
The pantry page shows an error: `Error fetching pantry items: {}` and items are not loading.

## Root Cause
The `PantryItem` table likely doesn't exist in your Supabase database yet, or there's a permission/RLS issue.

## Solution Steps

### Step 1: Check Browser Console for Detailed Error
1. Refresh the pantry page
2. Open browser console (F12)
3. Look for the new "Error details" log which will show:
   - `message`: The actual error message
   - `code`: Error code (e.g., "42P01" means table doesn't exist)
   - `details`: Additional details
   - `hint`: Supabase's suggestion

### Step 2: Create the PantryItem Table in Supabase

1. **Go to your Supabase project dashboard**
2. **Navigate to**: SQL Editor (left sidebar)
3. **Click**: "New query"
4. **Copy and paste** the contents of `database/create_pantry_table.sql`
5. **Click**: "Run" or press Ctrl+Enter
6. **Verify**: You should see "Success. No rows returned"

### Step 3: Verify Table Creation

1. **Go to**: Table Editor (left sidebar)
2. **Look for**: `PantryItem` table
3. **Check columns**:
   - `id` (int8, primary key)
   - `user_id` (uuid, foreign key to auth.users)
   - `name` (text)
   - `quantity` (text, nullable)
   - `created_at` (timestamptz)

### Step 4: Test the Pantry Page

1. **Refresh** the pantry page
2. **Try adding** an item (e.g., "Rice", "2 kg")
3. **Check console** for success logs:
   ```
   Adding pantry item: {user_id: "...", name: "Rice", quantity: "2 kg"}
   Pantry item added successfully: [{...}]
   ```
4. **Verify** the item appears in the list

### Step 5: Verify in Supabase Dashboard

1. **Go to**: Table Editor → PantryItem
2. **Check**: Your items should be visible
3. **Verify**: `user_id` matches your auth user ID

## Common Error Codes

| Code | Meaning | Solution |
|------|---------|----------|
| `42P01` | Table doesn't exist | Run the SQL script to create table |
| `42501` | Permission denied | Check RLS policies are set correctly |
| `23503` | Foreign key violation | Ensure user is authenticated |
| `PGRST116` | RLS policy blocking | Check RLS policies allow the operation |

## Alternative: Check Existing Table Name

If the table exists but with a different name:

1. **Go to**: Table Editor in Supabase
2. **Look for** tables like:
   - `pantry_items` (lowercase with underscore)
   - `pantryitems` (no underscore)
   - `Pantry` or `pantry`

If you find a different table name, update the code in `pantry/page.tsx`:
```tsx
// Change this line (around line 58):
.from("PantryItem")  // ← Change to match your actual table name
```

## Quick Test Query

Run this in Supabase SQL Editor to test if the table exists:
```sql
SELECT * FROM public."PantryItem" LIMIT 5;
```

If you get an error, the table doesn't exist. Run the create script.

## After Fixing

Once the table is created and working:
1. The pantry page should load without errors
2. You should be able to add/delete items
3. Statistics should update correctly
4. Items should persist after page refresh
