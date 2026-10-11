CREATE DATABASE IF NOT EXISTS homerent_rr7;
USE homerent_rr7;

DROP TABLE IF EXISTS TicketFeedback;
DROP TABLE IF EXISTS TicketResponses;
DROP TABLE IF EXISTS SupportTickets;
DROP TABLE IF EXISTS SupportCategory;
DROP TABLE IF EXISTS Users;

-- 1. Bảng Users (Hỗ trợ đa dạng vai trò và nhiều cư dân)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('Admin', 'Manager', 'Staff', 'Customer') NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE
);

-- 2. Bảng SupportCategory (Đầy đủ các loại khiếu nại trong quản lý căn hộ)
CREATE TABLE SupportCategory (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 3. Bảng SupportTickets (Lưu khiếu nại của bất kỳ phòng/người thuê nào)
CREATE TABLE SupportTickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    room_code VARCHAR(30) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Pending', 'In_Progress', 'Resolved', 'Closed') DEFAULT 'Pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES SupportCategory(category_id)
);

-- 4. Bảng TicketResponses (Lưu chi tiết các tin nhắn trao đổi)
CREATE TABLE TicketResponses (
    response_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL,
    responder_id INT NOT NULL,
    message TEXT NOT NULL,
    responded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES SupportTickets(ticket_id) ON DELETE CASCADE,
    FOREIGN KEY (responder_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 5. Bảng TicketFeedback (Đánh giá mức độ hài lòng)
CREATE TABLE TicketFeedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT NOT NULL UNIQUE,
    rating_stars INT NOT NULL CHECK (rating_stars BETWEEN 1 AND 5),
    feedback_comment TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES SupportTickets(ticket_id) ON DELETE CASCADE
);

-- DỮ LIỆU MẪU ĐA DẠNG NHIỀU PHÒNG & TÌNH HUỐNG
INSERT INTO Users (user_id, full_name, role, phone, email) VALUES
(1, 'Trần Văn Quản Lý', 'Manager', '0901234567', 'manager@homerent.com'),
(2, 'Nguyễn Thị Thu (Kỹ thuật)', 'Staff', '0907654321', 'staff@homerent.com'),
(3, 'Lê Hoàng Nam', 'Customer', '0912334455', 'nam.p302@gmail.com'),
(4, 'Phạm Thu Trang', 'Customer', '0988776655', 'trang.p105@gmail.com'),
(5, 'Hoàng Minh Tuấn', 'Customer', '0933112233', 'tuan.p408@gmail.com'),
(6, 'Đặng Mai Lan', 'Customer', '0944556677', 'lan.p204@gmail.com'),
(7, 'Võ Quốc Anh', 'Customer', '0966998877', 'anh.p501@gmail.com');

INSERT INTO SupportCategory (category_id, category_name, description) VALUES
(1, 'Sự cố Điện / Nước', 'Rò rỉ ống nước, chập điện, hỏng atomat, bóng đèn cháy'),
(2, 'Hỏng hóc thiết bị căn hộ', 'Lỗi điều hòa, máy giặt, tủ lạnh, bếp từ, bình nóng lạnh'),
(3, 'Cơ sở hạ tầng & Tiện ích', 'Khóa từ vân tay kẹt, cửa ban công không chốt, tường nứt, thấm dột trần'),
(4, 'Hợp đồng, Phí dịch vụ & Tiền cọc', 'Thắc mắc hóa đơn điện nước tháng, gia hạn hợp đồng thuê, hoàn tiền cọc'),
(5, 'An ninh & Trật tự công cộng', 'Tiếng ồn giờ giới nghiêm, để xe sai vị trí, rác thải hành lang');

INSERT INTO SupportTickets (ticket_id, user_id, category_id, room_code, title, description, status, created_at) VALUES
(101, 3, 1, 'P.302', 'Vòi sen phòng tắm bị rò rỉ nước', 'Vòi sen rò ở chân van từ tối qua làm ướt sàn nhà vệ sinh.', 'In_Progress', '2026-10-10 08:30:00'),
(102, 4, 2, 'P.105', 'Máy lạnh phòng ngủ không làm mát', 'Bật 16 độ cả tiếng nhưng chỉ có gió thoảng, nhờ thợ kiểm tra bảo dưỡng gas.', 'Resolved', '2026-10-09 14:15:00'),
(103, 5, 3, 'P.408', 'Khóa cửa vân tay thông minh báo pin yếu và kẹt chốt', 'Khóa cửa phát tiếng kêu bíp liên tục và mở bằng mã số rất khó khăn.', 'Pending', '2026-10-11 09:10:00'),
(104, 6, 4, 'P.204', 'Sai lệch chỉ số tiền điện nước tháng 09/2026', 'Phòng mình đi công tác 2 tuần nhưng số điện lại tăng gấp đôi so với tháng trước.', 'In_Progress', '2026-10-10 11:20:00'),
(105, 7, 5, 'P.501', 'Phòng bên cạnh mở nhạc to quá giờ quy định', 'Căn phòng bên cạnh mở nhạc to và ồn ào lúc 23h30 làm ảnh hưởng giấc ngủ.', 'Pending', '2026-10-11 00:15:00');

INSERT INTO TicketResponses (ticket_id, responder_id, message, responded_at) VALUES
(101, 3, 'Vòi sen rò chân van từ tối qua, nhờ anh kỹ thuật ghé xem giúp ạ.', '2026-10-10 08:31:00'),
(101, 2, 'Chào bạn Nam, 14h chiều nay kỹ thuật bên mình sẽ sang thay ron cao su nhé.', '2026-10-10 09:00:00'),
(102, 4, 'Máy lạnh phòng 105 bật mãi không mát ạ.', '2026-10-09 14:20:00'),
(102, 2, 'Thợ đã nạp gas R32 và vệ sinh lưới lọc hoàn tất rồi bạn nhé.', '2026-10-09 16:30:00'),
(104, 6, 'Nhờ ban quản lý kiểm tra lại đồng hồ cơ giúp mình nhé.', '2026-10-10 11:25:00'),
(104, 1, 'Chào chị Lan, kế toán đang rà soát lại ảnh chụp công tơ đầu tháng và sẽ báo lại ngay.', '2026-10-10 11:45:00');

INSERT INTO TicketFeedback (ticket_id, rating_stars, feedback_comment, created_at) VALUES
(102, 5, 'Kỹ thuật viên nhiệt tình, xử lý ngay trong buổi chiều.', '2026-10-09 17:00:00');