# HỆ THỐNG IT HELPDESK CỦA LUÂN - QUICK SETUP & ACTIVATION
> Hotline hỗ trợ kỹ thuật 24/7: **0966.228.133**

---

## ⚡ 1. Cài đặt trọn bộ phần mềm máy mới (All-in-One Setup)

Cài đặt đầy đủ: Chrome, UniKey, Adobe Reader, UltraViewer, Office 2021 + Kích hoạt Windows & Office, bật icon Desktop.

Mở **PowerShell (Run as Administrator)** và chạy:
```powershell
irm https://tinyurl.com/luanhelpdesk | iex
```

---

## ⚡ 2. Kích hoạt nhanh bản quyền Windows & Office (Quick Activation)

Chỉ kiểm tra và kích hoạt bản quyền Windows + Microsoft Office qua máy chủ KMS (không cài thêm phần mềm).

Mở **PowerShell (Run as Administrator)** và chạy:
```powershell
irm https://tinyurl.com/luanactive | iex
```

---

## 📦 Danh mục tính năng tự động thực thi:
1. **Tối ưu nguồn & Tắt Sleep/Hibernate:** Tắt timeout màn hình và sleep để máy không bị tắt ngang khi cài đặt.
2. **Bật biểu tượng Desktop hệ thống:** Tự động đưa **This PC, Thùng rác (Recycle Bin), Mạng (Network), Control Panel, User Files** ra ngoài màn hình chính.
3. **Google Chrome Enterprise 64-bit:** Tải & cài đặt bản Enterprise chính hãng (silent).
4. **Bộ gõ Tiếng Việt UniKey 4.6 RC2 64-bit:**
   - Cài đặt vào `C:\Program Files\UniKey`.
   - Cấu hình khởi động **1 nguồn duy nhất** qua *Task Scheduler* với quyền tương tác cao nhất (`RunLevel Highest`), gõ tiếng Việt được trên mọi app Administrator mà không bị UAC chặn và không bị mở lặp cửa sổ.
5. **Adobe Acrobat Reader DC:** Trình đọc file PDF chính hãng (offline silent installer).
6. **UltraViewer:** Phần mềm hỗ trợ kỹ thuật từ xa dự phòng.
7. **Microsoft Office 2021 ProPlus LTSC Volume (64-bit):**
   - Cài đặt đầy đủ: **Word, Excel, PowerPoint, Outlook**.
   - Tự động kích hoạt bản quyền qua máy chủ KMS (`LICENSED`).
8. **Kích hoạt bản quyền Windows:** Tự động kết nối máy chủ KMS kích hoạt bản quyền Windows.
9. **Chống trùng lặp Shortcut:** Chỉ tạo 1 biểu tượng duy nhất trên `Public Desktop` và tự động quét xóa các shortcut trùng tên ở Desktop cá nhân.
