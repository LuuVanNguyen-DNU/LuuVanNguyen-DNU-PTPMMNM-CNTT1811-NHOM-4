#!/usr/bin/env bash
set -u

project_name="OrderReturnManagementSystem"
echo "Kiểm tra dự án: $project_name"

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)" || exit 2
fail=0

check_tool() {
  if command -v "$1" >/dev/null 2>&1; then
    printf 'OK tool %s\n' "$1"
  else
    printf 'MISSING tool %s\n' "$1" >&2
    fail=$((fail + 1))
  fi
}

# Kiểm tra công cụ cần thiết (PHP, Git)
for tool in php git; do 
  check_tool "$tool"
done

# Kiểm tra các tệp cốt lõi của dự án 
required_files=(
  "README.md"
  "public/index.php"
)

for file in "${required_files[@]}"; do
  if [[ -f "$root/$file" ]]; then
    printf 'OK file %s\n' "$file"
  else
    printf 'MISSING file %s\n' "$file" >&2
    fail=$((fail + 1))
  fi
done

if [[ "$fail" -gt 0 ]]; then 
  exit 2; 
fi

# Kiểm tra cú pháp tệp điểm vào (entry point) chính
if php -l "$root/public/index.php"; then
  echo 'CHECK_ENV=PASS'
else
  echo 'CHECK_ENV=FAIL' >&2
  exit 1
fi