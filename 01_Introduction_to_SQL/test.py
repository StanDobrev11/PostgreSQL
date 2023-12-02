import re

input = 'dobrev81@gmail.com'
pattern = r'@(?P<domain>[a-z]+\.[a-z]+)'

result = re.sub(pattern, input)
