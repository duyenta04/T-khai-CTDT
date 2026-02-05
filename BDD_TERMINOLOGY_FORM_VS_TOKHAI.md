# BDD Terminology: "Form" vs "Tờ Khai"

## 🎯 Câu Hỏi Cốt Lõi

**Trong BDD scenarios, nên dùng "form" (form đăng ký) hay "tờ khai" (declaration)?**

---

## 📋 Phân Tích Theo BDD Best Practices

### Nguyên Tắc Vàng: **Business Domain Language**

> BDD nên sử dụng ngôn ngữ của business domain, không phải ngôn ngữ của UI/technical implementation.

---

## 🔍 So Sánh Chi Tiết

### "Form" - UI Implementation Term

```gherkin
❌ KHÔNG TỐT - UI/Technical language
Given người nộp thuế đang điền form
When người nộp thuế mở form đăng ký
Then form hiển thị trong vòng 2 giây
```

**Vấn đề:**
- "Form" là UI concept (HTML form, web form)
- Gắn liền với implementation (web interface)
- Nếu thay đổi UI (ví dụ: mobile app không có "form"), scenarios phải sửa
- Không phải ngôn ngữ business sử dụng

**Khi nào dùng "form":**
- ⚠️ Khi test UI behavior cụ thể (form validation)
- ⚠️ Khi stakeholders thực sự nói "form" trong daily conversation
- ⚠️ Tag @ui scenarios

---

### "Tờ Khai" - Business Domain Term

```gherkin
✅ TỐT - Business domain language
Given người nộp thuế đang tạo tờ khai
When người nộp thuế mở tờ khai mới
Then tờ khai hiển thị trong vòng 2 giây
```

**Ưu điểm:**
- "Tờ khai" là business concept (declaration document)
- Độc lập với implementation
- Đúng ngôn ngữ business/legal domain
- Stakeholders hiểu ngay
- Không phải sửa khi đổi UI

**Khi nào dùng "tờ khai":**
- ✅ Khi mô tả business behavior
- ✅ Khi nói về business entity
- ✅ Trong hầu hết scenarios

---

## 🎓 BDD Principles Applied

### 1. Ubiquitous Language (Domain-Driven Design)

> Use the language of the business domain in your specifications.

**Câu hỏi test:** *"Business stakeholders nói gì khi họ thảo luận?"*

- ✅ "Tạo tờ khai mới" - Business language
- ❌ "Điền form" - Technical/UI language

### 2. Implementation Independence

> Scenarios should describe WHAT, not HOW.

**Câu hỏi test:** *"Nếu đổi từ web form sang mobile app, scenario có cần sửa?"*

```gherkin
❌ Phải sửa (coupled to UI):
When người nộp thuế điền form trên web

✅ Không cần sửa (independent):
When người nộp thuế tạo tờ khai
```

---

## 💡 Recommendation: **Hybrid Approach**

### Cách Tiếp Cận Tốt Nhất

**Quy tắc:**
1. **Dùng "tờ khai"** cho business behaviors
2. **Dùng "form"** CHỈ khi test UI-specific behaviors
3. Phân biệt bằng tags

---

## ✅ Recommended Version

```gherkin
Feature: Đăng ký và thay đổi thông tin sử dụng chứng từ điện tử

  # Business behaviors - Dùng "tờ khai"
  @business-rules
  Scenario: Tạo tờ khai đăng ký mới
    Given người nộp thuế chưa có tờ khai nào được chấp nhận
    When người nộp thuế tạo tờ khai mới
    Then loại tờ khai mặc định là "Đăng ký mới"

  @business-rules
  Scenario: Nộp tờ khai cho cơ quan thuế
    Given người nộp thuế đã hoàn tất tờ khai
    When người nộp thuế nộp tờ khai
    Then tờ khai được gửi đến cơ quan thuế

  # UI-specific behaviors - Có thể dùng "form" nếu cần
  @ui @form-validation
  Scenario: Hiển thị lỗi validation khi điền form
    Given người nộp thuế đang tạo tờ khai
    When người nộp thuế nhập email không hợp lệ vào form
    Then form hiển thị lỗi tại trường email

  # Performance - Dùng "tờ khai" (business context)
  @performance
  Scenario: Tải tờ khai nhanh
    When người nộp thuế mở tờ khai mới
    Then tờ khai hiển thị trong vòng 2 giây
```

---

## 📊 Decision Matrix

| Tiêu chí | "Tờ khai" | "Form" |
|----------|-----------|---------|
| Business domain language | ✅ | ❌ |
| Implementation independent | ✅ | ❌ |
| Stakeholder comprehension | ✅ | ⚠️ |
| Long-term maintainability | ✅ | ❌ |
| UI behavior testing | ⚠️ | ✅ |
| API behavior testing | ✅ | ❌ |

**Legend:** ✅ Excellent, ⚠️ Acceptable, ❌ Not recommended

---

## 🔄 Refactoring Examples

### Example 1: Creating Declaration

#### ❌ Before (Form-focused)
```gherkin
Given người nộp thuế đang ở trang danh sách
When người nộp thuế mở form tạo mới
Then form hiển thị với các trường
```

#### ✅ After (Business-focused)
```gherkin
Given người nộp thuế đang ở danh sách tờ khai
When người nộp thuế tạo tờ khai mới
Then tờ khai mới được khởi tạo
```

---

### Example 2: Auto-fill

#### ❌ Before (UI-coupled)
```gherkin
When người nộp thuế mở form
Then form tự động điền thông tin đơn vị
```

#### ✅ After (Implementation-free)
```gherkin
When người nộp thuế tạo tờ khai mới
Then thông tin đơn vị được điền tự động
```

---

### Example 3: Validation

#### ⚠️ Acceptable (When testing UI validation)
```gherkin
@ui @validation
Scenario: Form validation hiển thị ngay lập tức
  Given người nộp thuế đang điền form
  When người nộp thuế nhập dữ liệu không hợp lệ
  Then form hiển thị lỗi ngay lập tức
```

#### ✅ Better (Business behavior)
```gherkin
@validation
Scenario: Kiểm tra dữ liệu không hợp lệ
  Given người nộp thuế đang tạo tờ khai
  When người nộp thuế nhập dữ liệu không hợp lệ
  Then hệ thống hiển thị lỗi validation
```

---

## 🎯 Practical Guidelines

### When to Use "Tờ Khai" (Declaration) - ✅ PREFERRED

**Use in 90% of scenarios:**
```gherkin
✅ người nộp thuế tạo tờ khai mới
✅ người nộp thuế hoàn tất tờ khai
✅ người nộp thuế nộp tờ khai
✅ tờ khai được gửi đến cơ quan thuế
✅ tờ khai có trạng thái "Đã gửi"
✅ thông tin tờ khai được lưu
✅ tờ khai mới xuất hiện trong danh sách
```

**Business reasons:**
- Documents are called "tờ khai" in Vietnamese tax law
- Stakeholders say "tờ khai" in meetings
- Legal/regulatory documents use "tờ khai"
- Independent of how it's presented (web/mobile/API)

---

### When to Use "Form" - ⚠️ ONLY WHEN NECESSARY

**Use in <10% of scenarios, only for UI-specific behaviors:**
```gherkin
⚠️ form hiển thị lỗi validation
⚠️ form tự động save
⚠️ form có tooltip
⚠️ form responsive trên mobile
```

**UI-specific reasons:**
- Testing actual HTML form behavior
- Testing form-specific features (auto-save, tooltips)
- Testing responsive design
- Always tag with @ui

---

## 📝 Concrete Examples from Your Domain

### ✅ RECOMMENDED: Business-Focused

```gherkin
Feature: Đăng ký sử dụng chứng từ điện tử

  Background:
    Given người nộp thuế đã đăng nhập vào hệ thống

  Rule: Tạo tờ khai mới
  
    Scenario: Khởi tạo tờ khai đăng ký mới
      When người nộp thuế tạo tờ khai mới
      Then tờ khai được khởi tạo với thông tin mặc định

    Scenario: Hoàn tất và nộp tờ khai
      Given người nộp thuế đã tạo tờ khai
      And người nộp thuế đã điền đầy đủ thông tin
      When người nộp thuế nộp tờ khai
      Then tờ khai được gửi đến cơ quan thuế

    Scenario: Lưu tờ khai nháp
      Given người nộp thuế đang tạo tờ khai
      When người nộp thuế lưu tờ khai nháp
      Then tờ khai được lưu với trạng thái "Nháp"
```

---

### ❌ NOT RECOMMENDED: UI-Focused

```gherkin
Feature: Form đăng ký chứng từ điện tử

  Scenario: Mở form đăng ký
    When người nộp thuế mở form đăng ký
    Then form hiển thị với các trường bắt buộc

  Scenario: Điền form
    Given người nộp thuế đang ở form đăng ký
    When người nộp thuế điền form
    Then form tự động validate

  Scenario: Submit form
    Given người nộp thuế đã điền form
    When người nộp thuế submit form
    Then form được gửi đi
```

**Problems:**
- Coupled to web UI
- Can't reuse for mobile app
- Not business language
- Hard to understand for legal/tax stakeholders

---

## 🔧 Refactoring Your Current Feature

### Current Issues in Your Feature

#### Location 1: Performance
```gherkin
❌ Current:
@performance
Scenario: Form tải nhanh
  When người nộp thuế mở form đăng ký
  Then form hiển thị trong vòng 2 giây

✅ Should be:
@performance
Scenario: Tải tờ khai nhanh
  When người nộp thuế tạo tờ khai mới
  Then tờ khai hiển thị trong vòng 2 giây
```

#### Location 2: Auto-fill
```gherkin
❌ Current:
Scenario: Hiển thị thông tin đơn vị từ hồ sơ
  When người nộp thuế mở form đăng ký
  Then thông tin đơn vị hiển thị từ hồ sơ

✅ Should be:
Scenario: Hiển thị thông tin đơn vị từ hồ sơ
  When người nộp thuế tạo tờ khai mới
  Then thông tin đơn vị hiển thị từ hồ sơ
```

#### Location 3: Contact Info
```gherkin
❌ Current:
Scenario: Yêu cầu nhập đầy đủ thông tin liên hệ
  Given người nộp thuế đang điền form

✅ Should be:
Scenario: Yêu cầu nhập đầy đủ thông tin liên hệ
  Given người nộp thuế đang tạo tờ khai
```

---

## 🎯 Final Recommendation

### **USE "TỜ KHAI" as Default** ✅

**Reasons:**
1. ✅ Business domain term (legal/tax domain)
2. ✅ Implementation independent
3. ✅ Stakeholder language
4. ✅ Long-term maintainable
5. ✅ API/UI/Mobile agnostic

### **USE "FORM" Sparingly** ⚠️

**Only when:**
1. Testing UI-specific form behavior
2. Testing HTML form features
3. Tagged with @ui
4. Cannot describe with "tờ khai"

---

## 📚 Glossary

### Business Domain Terms (Preferred)
- ✅ Tờ khai (Declaration)
- ✅ Nộp tờ khai (Submit declaration)
- ✅ Tạo tờ khai (Create declaration)
- ✅ Hoàn tất tờ khai (Complete declaration)
- ✅ Lưu tờ khai (Save declaration)

### UI/Technical Terms (Use Sparingly)
- ⚠️ Form
- ⚠️ Điền form (Fill form)
- ⚠️ Submit form
- ⚠️ Validate form

### Context-Specific
- ✅ "Tờ khai" - Business behavior scenarios (90%)
- ⚠️ "Form" - UI-specific scenarios tagged @ui (10%)

---

## 💡 Key Takeaway

> **Default to business language ("tờ khai"). Only use technical language ("form") when absolutely necessary for UI-specific testing.**

**The BDD Mantra:**
*"Speak the language of the business, not the language of the code."*

---

## ✅ Action Items

1. **Refactor current feature:**
   - Replace "form" with "tờ khai" in business scenarios
   - Keep "form" only in @ui tagged scenarios
   - Ensure consistency

2. **Update step definitions:**
   - Map both terms to same implementation if needed
   - But keep Gherkin using "tờ khai"

3. **Team alignment:**
   - Share this guideline with team
   - Agree on terminology
   - Use in future scenarios

---

**Author:** Claude AI Assistant  
**Date:** 2026-02-05  
**Topic:** BDD Terminology Best Practices  
**Recommendation:** Use "Tờ Khai" (90%) + "Form" (@ui only, 10%)
