-- Add age, height, and weight columns to User table
ALTER TABLE public."User"
ADD COLUMN IF NOT EXISTS age integer,
ADD COLUMN IF NOT EXISTS height_cm numeric(5,2),  -- e.g., 175.50 cm
ADD COLUMN IF NOT EXISTS weight_kg numeric(5,2);  -- e.g., 70.50 kg

-- Add check constraints for reasonable values
ALTER TABLE public."User"
ADD CONSTRAINT check_age_range CHECK (age IS NULL OR (age >= 0 AND age <= 150));

ALTER TABLE public."User"
ADD CONSTRAINT check_height_range CHECK (height_cm IS NULL OR (height_cm >= 50 AND height_cm <= 300));

ALTER TABLE public."User"
ADD CONSTRAINT check_weight_range CHECK (weight_kg IS NULL OR (weight_kg >= 20 AND weight_kg <= 500));
