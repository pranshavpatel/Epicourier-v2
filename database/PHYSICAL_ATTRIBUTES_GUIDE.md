# Adding Physical Attributes to User Profile

## Overview
Successfully added age, height, and weight fields to the user profile system.

---

## 📊 Database Changes

### SQL Script: `database/add_user_physical_attributes.sql`

**New Columns Added:**
- `age` (integer) - User's age in years
- `height_cm` (numeric 5,2) - Height in centimeters (e.g., 175.50)
- `weight_kg` (numeric 5,2) - Weight in kilograms (e.g., 70.50)

**Validation Constraints:**
- Age: 0-150 years
- Height: 50-300 cm
- Weight: 20-500 kg

**To Apply:**
1. Go to Supabase Dashboard → SQL Editor
2. Run the script: `database/add_user_physical_attributes.sql`
3. Verify columns appear in the User table

---

## 🎨 Frontend Changes

### File: `web/src/app/dashboard/profile/page.tsx`

#### 1. **New State Variables**
```tsx
const [age, setAge] = useState("");
const [height, setHeight] = useState("");
const [weight, setWeight] = useState("");
```

#### 2. **Updated Profile Completeness**
Now includes 7 sections (was 4):
- Age (14%)
- Height (14%)
- Weight (14%)
- Dietary Preferences (15%)
- Allergies (15%)
- Kitchen Equipment (14%)
- Goals (14%)

#### 3. **New UI Section: Physical Attributes**
- **Color theme**: Indigo (to distinguish from other sections)
- **Icon**: UserCircle
- **Layout**: 3-column grid (responsive)
- **Fields**:
  - Age (number input, 0-150)
  - Height in cm (number input with decimals, 50-300)
  - Weight in kg (number input with decimals, 20-500)

#### 4. **Database Integration**
```tsx
// Fetch
setAge(data.age?.toString() || "");
setHeight(data.height_cm?.toString() || "");
setWeight(data.weight_kg?.toString() || "");

// Save
const updates = {
    age: age.trim() ? parseInt(age) : null,
    height_cm: height.trim() ? parseFloat(height) : null,
    weight_kg: weight.trim() ? parseFloat(weight) : null,
    // ... other fields
};
```

---

## 🎯 Features

### Input Validation
- **Type**: Number inputs with min/max constraints
- **Decimals**: Height and weight support decimal values (step="0.1")
- **Optional**: All fields are optional (can be left empty)
- **Null handling**: Empty fields save as `null` in database

### Visual Design
- Indigo color scheme for the Physical Attributes section
- 3-column responsive grid (stacks on mobile)
- Consistent with other profile sections
- Clear labels and placeholders

### User Experience
- Placeholder examples (e.g., "25", "175", "70")
- Helper text: "Help us calculate your nutritional needs more accurately"
- Real-time profile completeness updates
- Console logging for debugging

---

## 🧪 Testing Instructions

### 1. Apply Database Changes
```sql
-- Run in Supabase SQL Editor
ALTER TABLE public."User"
ADD COLUMN IF NOT EXISTS age integer,
ADD COLUMN IF NOT EXISTS height_cm numeric(5,2),
ADD COLUMN IF NOT EXISTS weight_kg numeric(5,2);
```

### 2. Test the Profile Page

**Navigate to Profile:**
1. Go to `/dashboard/profile`
2. Scroll to "Physical Attributes" section

**Test Input:**
1. Enter age: `25`
2. Enter height: `175.5`
3. Enter weight: `70.5`
4. Click "Save Profile"

**Verify:**
- ✅ Toast notification: "Profile updated successfully"
- ✅ Console log shows saved data
- ✅ Profile completeness increases
- ✅ Refresh page - values persist

**Test Edge Cases:**
1. Leave fields empty - should save as `null`
2. Enter invalid values (e.g., age > 150) - browser validation prevents
3. Enter decimals for height/weight - should save correctly

### 3. Verify in Database

**Supabase Dashboard:**
1. Go to Table Editor → User
2. Find your user record
3. Check columns: `age`, `height_cm`, `weight_kg`
4. Values should match what you entered

### 4. Test Profile Completeness

**Empty Profile:**
- Completeness: 0%

**Fill Physical Attributes Only:**
- Completeness: ~42% (3 out of 7 sections)

**Fill All Sections:**
- Completeness: 100%

---

## 📝 Data Types Explained

### Why `numeric(5,2)` for height and weight?

**Format**: `numeric(precision, scale)`
- `precision = 5`: Total number of digits
- `scale = 2`: Digits after decimal point

**Examples:**
- `175.50` ✅ (5 digits total, 2 after decimal)
- `99.99` ✅
- `1234.5` ✅
- `12345.67` ❌ (6 digits total, exceeds precision)

**Why this choice:**
- Supports most human heights: 50.00 - 999.99 cm
- Supports most human weights: 20.00 - 999.99 kg
- Allows precision to 0.01 (useful for tracking small changes)

---

## 🔄 Future Enhancements

### Potential Additions:
1. **Unit Toggle**: Switch between metric (cm/kg) and imperial (in/lbs)
2. **BMI Calculator**: Auto-calculate and display BMI
3. **Health Metrics**: Add body fat %, muscle mass, etc.
4. **Goal Tracking**: Track changes over time
5. **Validation Messages**: Custom error messages for invalid inputs

### Integration with Recommender:
The recommender system can now use these values to:
- Calculate BMR (Basal Metabolic Rate)
- Adjust calorie recommendations
- Personalize portion sizes
- Consider age-specific nutritional needs

---

## 🎨 UI Color Scheme

| Section | Color | Icon |
|---------|-------|------|
| Physical Attributes | Indigo | UserCircle |
| Dietary Preferences | Emerald | Utensils |
| Allergies | Red | AlertTriangle |
| Kitchen Equipment | Blue | ChefHat |
| Goals | Purple | Info |

---

## ✅ Summary

**Database:**
- ✅ Added 3 new columns with validation constraints
- ✅ All fields are optional (nullable)
- ✅ Proper data types for precision

**Frontend:**
- ✅ New Physical Attributes section with indigo theme
- ✅ 3-column responsive grid layout
- ✅ Number inputs with min/max validation
- ✅ Updated profile completeness calculation
- ✅ Proper null handling for empty fields
- ✅ Console logging for debugging

**User Experience:**
- ✅ Clear labels and placeholders
- ✅ Helper text explaining purpose
- ✅ Real-time completeness updates
- ✅ Consistent visual design
- ✅ Mobile responsive
