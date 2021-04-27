import json 

start = 0x0000
end = 0xffff

cp2u8 = {}

for i in range(start, end + 1):
  key = format(i, 'x').rjust(4, '0')
  # Skip ascii control chars and vertical tab (would otherwise just be recoded as \u00..),
  # surrogates (not allowed in Python), and 0xfffe and oxffff chars (break Io compiler).
  if (i > 0x0007 and i < 0x000B) or (i > 0x000B and i < 0x000E) or (i > 0x001F and i < 0x007F) \
    or (i > 0x007F and i < 0xD800) or (i > 0xDFFF and i < 0xfffe):
    val = chr(int('0x' + key, 16))
  else:
    val = ''
  cp2u8[key] = val

with open('cp2u8.json', 'w',encoding='utf8') as f: 
  json.dump(cp2u8, f, ensure_ascii=False, indent=4, sort_keys=True)

