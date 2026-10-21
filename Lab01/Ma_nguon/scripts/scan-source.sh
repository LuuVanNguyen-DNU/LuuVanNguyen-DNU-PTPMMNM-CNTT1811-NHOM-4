#!/usr/bin/env bash
set -u

# Kiểm tra đầu vào: Xác định thư mục cần quét (mặc định là thư mục hiện tại hoặc tham số truyền vào)
target_dir="${1:-.}"

# TODO 1: Kiểm tra xem thư mục đầu vào có tồn tại và đọc được không
if [[ ! -d "$target_dir" ]]; then
    echo "ERROR: Directory not found: $target_dir" >&2
    exit 2
fi

total=0
pass=0
fail_count=0

# Duyệt đệ quy qua các tệp PHP, xử lý an toàn với tên tệp chứa khoảng trắng
while IFS= read -r -d '' file; do
    total=$((total + 1))
    
    # TODO 2: Kiểm tra cú pháp tệp PHP bằng php -l mà không làm dừng vòng lặp khi gặp tệp lỗi
    if php -l "$file" >/dev/null 2>&1; then
        pass=$((pass + 1))
        printf 'PASS: %s\n' "$file"
    else
        fail_count=$((fail_count + 1))
        printf 'FAIL: %s\n' "$file" >&2
    fi
done < <(find "$target_dir" -type f -name "*.php" -print0)

# Kiểm tra nếu không có tệp PHP nào trong thư mục
if [[ "$total" -eq 0 ]]; then
    echo "ERROR: No PHP files found in $target_dir" >&2
    exit 2
fi

# In kết quả tổng hợp theo chuẩn yêu cầu của Lab
printf 'TOTAL=%d PASS=%d FAIL=%d\n' "$total" "$pass" "$fail_count"

# TODO 3: Trả mã thoát tương ứng (0 nếu không có lỗi, 1 nếu có tệp sai cú pháp)
if [[ "$fail_count" -gt 0 ]]; then
    exit 1
else
    exit 0
fi