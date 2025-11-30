# Pantry Database Schema Fix

## The Problem

Your original SQL script used a **3-table relationship** that the frontend code wasn't accounting for.

### Database Schema (What You Have)
```
auth.users (Supabase Auth)
    ↓ (auth_id)
public.User
    ↓ (user_id references User.id)
public.PantryItem
```

### What the Frontend Was Trying to Do
```tsx
// ❌ WRONG - This was trying to use auth.uid() directly
const { data } = await supabase
    .from("PantryItem")
    .eq("user_id", user.id)  // user.id is a UUID from auth.users
```

But your `PantryItem.user_id` is a `bigint` that references `User.id`, not `auth.users.id`!

## The Solution

Updated the frontend to use the correct 3-table flow:

```tsx
// ✅ CORRECT - Get User.id first, then use it
// Step 1: Get User.id from User table using auth_id
const { data: userData } = await supabase
    .from("User")
    .select("id")
    .eq("auth_id", user.id)  // user.id is auth UUID
    .single();

// Step 2: Use User.id to query PantryItem
const { data } = await supabase
    .from("PantryItem")
    .eq("user_id", userData.id)  // userData.id is the bigint
```

## What Was Changed

### File: `web/src/app/dashboard/pantry/page.tsx`

#### 1. `fetchItems()` function
- **Before**: Directly used `auth.uid()` to query PantryItem
- **After**: First fetches `User.id` using `auth_id`, then uses that to query PantryItem

#### 2. `handleAddItem()` function
- **Before**: Inserted with `user_id: user.id` (auth UUID)
- **After**: First fetches `User.id`, then inserts with `user_id: userData.id` (bigint)

## Why Your Original SQL Was Correct

Your RLS policies were actually correct for this schema:

```sql
CREATE POLICY "Users can view their own pantry items" ON public."PantryItem"
FOR SELECT USING (
  EXISTS (
    SELECT 1 FROM public."User" u
    WHERE u.id = public."PantryItem".user_id
    AND u.auth_id = auth.uid()
  )
);
```

This policy:
1. Checks if there's a User record where `User.id = PantryItem.user_id`
2. AND that User's `auth_id` matches the current authenticated user

The RLS policies work perfectly with your schema - the frontend just needed to be updated!

## Testing

Now when you:
1. **Refresh the pantry page** - Should load items without errors
2. **Add an item** - Should successfully insert
3. **Check console logs** - Should see:
   ```
   Fetching pantry items for auth user: <uuid>
   User database ID: <bigint>
   Pantry items loaded: [...]
   ```

## No Need for My SQL Script

You can **ignore** the `create_pantry_table.sql` file I created earlier. Your original SQL schema is correct - it was just a frontend code mismatch!
