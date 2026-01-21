# Refactor UI Design Based on Requirements

### UI TO REFACTOR:
$ARGUMENTS

### CONSTANTS
* FRAMEWORK = React with shadcn
* STYLING = tailwind v4
* DEFAULT_STYLE = Notion.so aesthetic (clean, minimal, restrained color palette)

### VARIABLES
* `user_requirements` - Extracted from $ARGUMENTS
* `source_component` - The original UI to be refactored

### OBJECTIVE
Directly refactor the existing React component based on user requirements specified in $ARGUMENTS. Apply changes in-place while maintaining the core functionality.

### Input Options
* If the user provides a React component file → Analyze and refactor based on $ARGUMENTS
* If the user provides an image/screenshot → Recreate as React component following $ARGUMENTS
* If the user provides a link → Inspect and rebuild according to $ARGUMENTS
* If nothing is provided → Stop and ask: "Please provide your current React component or UI reference (code, image, or link) that you'd like me to improve"

### Refactoring Process

1. **Parse $ARGUMENTS** to extract:
   - Style requirements (e.g., "make it more like Notion", "reduce colors", "add more spacing")
   - Functional requirements (e.g., "keep the search bar prominent", "simplify navigation")
   - Constraints (e.g., "maintain brand colors", "keep accessibility features")

2. **Analyze existing component** to identify:
   - Current structure and patterns
   - Areas that need modification based on requirements
   - Components that should remain unchanged

3. **Apply direct modifications based on $ARGUMENTS:**

   **Style Transformations:**
   - If "Notion-like" → Replace colors with gray palette, simplify borders
   - If "reduce colors" → Limit to primary + 1 accent color
   - If "modern" → Update to latest patterns
   - If "clean" → Increase whitespace, remove decorative elements
   - If "minimal" → Remove unnecessary visual elements


4. **Refactoring Rules:**
   - Preserve all functional logic and event handlers
   - Maintain component prop interfaces
   - Keep accessibility attributes
   - Update only visual/styling aspects unless functional changes are explicitly requested
   - Add comments where significant changes are made

5. **Output Structure:**
   Return the refactored component maintaining the original file structure:
   ```
   ComponentName.tsx (refactored version)
   ComponentName.module.css (refactored styles)
   ```

