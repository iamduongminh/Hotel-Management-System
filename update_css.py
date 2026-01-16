
import os

file_path = r"c:\Users\huydi\Desktop\personal_project\hotel_management_sytem_web\src\main\resources\static\css\style.css"

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# The content to replace (old CSS)
old_css_start = "/* --- Price Range Slider Styles --- */"
old_css_end = "    outline: none;\n}"

# Find start and end indices
start_idx = content.find(old_css_start)
end_idx = content.find(old_css_end)

if start_idx != -1 and end_idx != -1:
    end_idx += len(old_css_end)
    
    # New CSS content
    new_css = """/* --- Price Range Slider Styles --- */
.price-range-filter {
    display: flex;
    flex-direction: column;
    min-width: 240px;
    gap: 8px;
    padding: 0 8px;
}

.range-display {
    font-size: 13px;
    color: var(--text-primary);
    font-weight: 600;
    text-align: center;
    background: rgba(15, 23, 42, 0.4);
    padding: 6px 10px;
    border-radius: 6px;
    border: 1px solid var(--border-light);
    display: flex;
    justify-content: space-between;
    align-items: center;
    backdrop-filter: blur(4px);
}

.range-display span {
    font-variant-numeric: tabular-nums;
}

.range-slider-container {
    position: relative;
    height: 40px; /* Increased touch area */
    display: flex;
    align-items: center;
}

.slider-track {
    position: absolute;
    width: 100%;
    height: 6px; /* Thicker track */
    background: rgba(148, 163, 184, 0.2);
    border-radius: 3px;
    z-index: 1;
}

.range-slider-container input[type="range"] {
    position: absolute;
    width: 100%;
    pointer-events: none;
    -webkit-appearance: none;
    appearance: none;
    background: transparent;
    z-index: 2;
    height: 6px;
}

/* Slider Thumb Styles - Webkit */
.range-slider-container input[type="range"]::-webkit-slider-thumb {
    pointer-events: auto;
    -webkit-appearance: none;
    width: 20px;
    height: 20px;
    background: white;
    border: 2px solid var(--primary);
    border-radius: 50%;
    cursor: grab;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    margin-top: 0;
    transition: transform 0.1s ease, box-shadow 0.1s ease, background-color 0.2s;
}

.range-slider-container input[type="range"]::-webkit-slider-thumb:hover {
    transform: scale(1.15);
    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
}

.range-slider-container input[type="range"]::-webkit-slider-thumb:active {
    cursor: grabbing;
    transform: scale(1.25);
    background: var(--primary);
    border-color: white;
}

/* Slider Thumb Styles - Firefox */
.range-slider-container input[type="range"]::-moz-range-thumb {
    pointer-events: auto;
    width: 20px;
    height: 20px;
    background: white;
    border: 2px solid var(--primary);
    border-radius: 50%;
    cursor: grab;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    border: none;
    transition: transform 0.1s ease, box-shadow 0.1s ease, background-color 0.2s;
}

.range-slider-container input[type="range"]::-moz-range-thumb:hover {
    transform: scale(1.15);
    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.15);
}

.range-slider-container input[type="range"]::-moz-range-thumb:active {
    cursor: grabbing;
    transform: scale(1.25);
    background: var(--primary);
}

/* Remove default focus outline */
.range-slider-container input[type="range"]:focus {
    outline: none;
}"""

    # Perform replacement
    new_content = content[:start_idx] + new_css + content[end_idx:]
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print("CSS updated successfully!")
else:
    print("Could not find the CSS block to replace.")
    print(f"Start index: {start_idx}, End index: {end_idx}")

