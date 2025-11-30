-- Create PantryItem table if it doesn't exist
CREATE TABLE IF NOT EXISTS public."PantryItem" (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    quantity TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_pantryitem_user_id ON public."PantryItem"(user_id);

-- Enable Row Level Security
ALTER TABLE public."PantryItem" ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view their own pantry items" ON public."PantryItem";
DROP POLICY IF EXISTS "Users can insert their own pantry items" ON public."PantryItem";
DROP POLICY IF EXISTS "Users can update their own pantry items" ON public."PantryItem";
DROP POLICY IF EXISTS "Users can delete their own pantry items" ON public."PantryItem";

-- Create RLS policies
CREATE POLICY "Users can view their own pantry items"
    ON public."PantryItem"
    FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own pantry items"
    ON public."PantryItem"
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own pantry items"
    ON public."PantryItem"
    FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own pantry items"
    ON public."PantryItem"
    FOR DELETE
    USING (auth.uid() = user_id);

-- Grant permissions
GRANT ALL ON public."PantryItem" TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public."PantryItem_id_seq" TO authenticated;
