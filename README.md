# HỆ THỐNG IT HELPDESK CỦA LUÂN - QUICK SETUP ALL-IN-ONE
> Hotline hỗ trợ kỹ thuật 24/7: **0966.228.133**

Bộ script tự động cài đặt trọn gói phần mềm cho máy tính mới cài Windows hoặc cài đặt chuẩn văn phòng.

---

## ⚡ Hướng dẫn chạy nhanh 1 dòng lệnh (One-liner)

Mở **PowerShell (Run as Administrator)** trên máy tính cần cài đặt và dán dòng lệnh sau:

### Cách 1 (Dùng link TinyURL siêu ngắn):
```powershell
irm https://tinyurl.com/2b8hjelh | iex
```

### Cách 2 (Dùng link Raw GitHub chính thức):
```powershell
irm https://raw.githubusercontent.com/thanhluanlvl/LuanHelpdesk-QuickSetup/main/install.ps1 | iex
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
8. **Chống trùng lặp Shortcut:** Chỉ tạo 1 biểu tượng duy nhất trên `Public Desktop` và tự động quét xóa các shortcut trùng tên ở Desktop cá nhân.
