Quy trình thêm tính năng mới:
Bắt đầu từ Service Layer:
Thêm logic xử lý Facebook API mới
Xử lý lỗi và validation
Đảm bảo tính đóng gói và tái sử dụng
Cập nhật Message Parser:
Thêm các method parse dữ liệu mới từ Facebook webhook
Validate và transform data
Cập nhật Job Layer:
Thêm xử lý cho webhook events mới
Kết nối parser với service
Thêm Controller Actions:
Xử lý requests từ frontend
Authorization và validation
Gọi đến service layer
Viết Tests:
Unit tests cho service
Integration tests cho controller
Test cases cho các trường hợp lỗi
Lưu ý quan trọng:
Tuân thủ cấu trúc hiện tại:
Giữ nguyên cách tổ chức code
Sử dụng các patterns có sẵn
Error Handling:
Xử lý lỗi Facebook một cách nhất quán
Log lỗi để debug
Testing:
Coverage đầy đủ cho code mới
Đảm bảo không ảnh hưởng đến code cũ
Documentation:
Comment code mới
Cập nhật README nếu cần