# language: vi
@document-declaration
Feature: Đăng ký và thay đổi thông tin sử dụng chứng từ điện tử
  Để có thể sử dụng chứng từ điện tử hợp pháp
  Với vai trò người nộp thuế
  Tôi cần đăng ký hoặc thay đổi thông tin với cơ quan thuế

  Background:
    Given người nộp thuế đã đăng nhập vào hệ thống
    And người nộp thuế có quyền đăng ký phát hành chứng từ điện tử

  Rule: Xác định loại tờ khai

    @type-selection
    Scenario: Mặc định chọn "Đăng ký mới" khi chưa có đăng ký
      Given chưa có tờ khai nào được cơ quan thuế chấp nhận
      When người nộp thuế mở form đăng ký
      Then loại tờ khai mặc định là "Đăng ký mới"

    @type-selection
    Scenario: Cho phép chọn cả hai loại khi chưa có đăng ký
      Given chưa có tờ khai nào được cơ quan thuế chấp nhận
      When người nộp thuế mở form đăng ký
      Then người nộp thuế có thể chọn "Đăng ký mới" hoặc "Thay đổi thông tin"

    @type-selection
    Scenario: Mặc định chọn "Thay đổi thông tin" khi đã có đăng ký
      Given đã có tờ khai được cơ quan thuế chấp nhận
      When người nộp thuế mở form đăng ký
      Then loại tờ khai mặc định là "Thay đổi thông tin"

    @type-selection
    Scenario: Chỉ cho phép "Thay đổi thông tin" khi đã có đăng ký
      Given đã có tờ khai được cơ quan thuế chấp nhận
      When người nộp thuế mở form đăng ký
      Then người nộp thuế chỉ có thể chọn "Thay đổi thông tin"

  Rule: Thông tin đơn vị tự động được điền

    @auto-fill
    Scenario: Hiển thị thông tin đơn vị từ hồ sơ
      When người nộp thuế mở form đăng ký
      Then thông tin đơn vị hiển thị từ hồ sơ
        | Tên đơn vị           |
        | Mã số thuế           |
        | Cơ quan thuế quản lý |

    @auto-fill
    Scenario: Không cho phép chỉnh sửa thông tin đơn vị
      Given người nộp thuế đang xem form đăng ký
      When người nộp thuế thử chỉnh sửa thông tin đơn vị
      Then các trường thông tin đơn vị không thể chỉnh sửa

  Rule: Thông tin liên hệ

    @contact-info @required
    Scenario Outline: Yêu cầu nhập đầy đủ thông tin liên hệ
      Given người nộp thuế đang điền form
      When người nộp thuế bỏ trống <field>
      And người nộp thuế gửi tờ khai
      Then hệ thống hiển thị lỗi <error_message>

      Examples:
        | field              | error_message                           |
        | Người liên hệ      | Người liên hệ không được để trống       |
        | Điện thoại liên hệ | Điện thoại liên hệ không được để trống  |
        | Địa chỉ liên hệ    | Địa chỉ liên hệ không được để trống     |
        | Email              | Địa chỉ email không được để trống       |

    @contact-info @validation
    Scenario: Kiểm tra định dạng số điện thoại
      Given người nộp thuế đang điền form
      When người nộp thuế nhập số điện thoại không hợp lệ
      Then hệ thống hiển thị lỗi "Số điện thoại không hợp lệ"

    @contact-info @validation
    Scenario: Kiểm tra định dạng email
      Given người nộp thuế đang điền form
      When người nộp thuế nhập email không hợp lệ
      Then hệ thống hiển thị lỗi "Email không đúng định dạng"

  Rule: Đối tượng phát hành

    @issuer-type @required
    Scenario: Yêu cầu chọn ít nhất một đối tượng phát hành
      Given người nộp thuế đang điền form
      When người nộp thuế không chọn đối tượng phát hành nào
      And người nộp thuế gửi tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một đối tượng phát hành"

    @issuer-type
    Scenario: Hiển thị các lựa chọn đối tượng phát hành
      When người nộp thuế xem form đăng ký
      Then hệ thống hiển thị các đối tượng phát hành
        | Tổ chức, cá nhân phát hành                  |
        | Cơ quan thuế phát hành                      |

  Rule: Loại hình sử dụng chứng từ điện tử

    @document-type @required
    Scenario: Yêu cầu chọn ít nhất một loại chứng từ
      Given người nộp thuế đang điền form
      When người nộp thuế không chọn loại chứng từ nào
      And người nộp thuế gửi tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một loại chứng từ điện tử"

    @document-type
    Scenario: Hiển thị các loại chứng từ có sẵn
      When người nộp thuế xem form đăng ký
      Then hệ thống hiển thị các loại chứng từ
        | Chứng từ điện tử khấu trừ thuế thu nhập cá nhân                               |
        | Chứng từ điện tử đối với hoạt động kinh doanh nền tảng số, kinh doanh thương mại điện tử |
        | Biên lai điện tử                                                              |

    @document-type @conditional
    Scenario: Hiển thị loại biên lai khi chọn "Biên lai điện tử"
      Given người nộp thuế đang điền form
      When người nộp thuế chọn "Biên lai điện tử"
      Then hệ thống hiển thị các loại biên lai

    @document-type @conditional
    Scenario: Ẩn loại biên lai khi bỏ chọn "Biên lai điện tử"
      Given người nộp thuế đã chọn "Biên lai điện tử"
      When người nộp thuế bỏ chọn "Biên lai điện tử"
      Then hệ thống ẩn các loại biên lai

  Rule: Hình thức gửi dữ liệu

    @submission-method @required
    Scenario: Yêu cầu chọn ít nhất một hình thức gửi
      Given người nộp thuế đang điền form
      When người nộp thuế không chọn hình thức gửi nào
      And người nộp thuế gửi tờ khai
      Then hệ thống hiển thị lỗi "Phải chọn ít nhất một hình thức gửi dữ liệu"

    @submission-method
    Scenario: Hiển thị các hình thức gửi dữ liệu
      When người nộp thuế xem form đăng ký
      Then hệ thống hiển thị các hình thức gửi
        | Truyền công thông tin điện tử của cơ quan thuế                                       |
        | Thông qua tổ chức cung cấp dịch vụ hóa đơn điện tử                                   |
        | Thông qua tổ chức cung cấp dịch vụ hóa đơn điện tử được Tổng cục Thuế ủy thác       |

  Rule: Thông tin chữ ký số

    @digital-signature @required
    Scenario: Yêu cầu có ít nhất một chữ ký số
      Given người nộp thuế đang điền form
      When người nộp thuế không thêm chữ ký số nào
      And người nộp thuế gửi tờ khai
      Then hệ thống hiển thị lỗi "Phải có ít nhất một chữ ký số hợp lệ"

    @digital-signature
    Scenario: Thêm chữ ký số vào danh sách
      Given người nộp thuế đang điền form
      When người nộp thuế thêm chữ ký số hợp lệ
      Then chữ ký số xuất hiện trong danh sách

    @digital-signature
    Scenario: Hiển thị thông tin chữ ký số
      Given người nộp thuế đã thêm chữ ký số
      Then hệ thống hiển thị thông tin chữ ký
        | Tổ chức chứng thực CKS |
        | Số Serial CKS          |
        | Hiệu lực từ ngày       |
        | Hiệu lực đến ngày      |
        | Hình thức đăng ký      |

    @digital-signature
    Scenario: Xóa chữ ký số khỏi danh sách
      Given người nộp thuế đã thêm chữ ký số
      When người nộp thuế xóa chữ ký số
      Then chữ ký số biến mất khỏi danh sách

  Rule: Hủy bỏ và Nộp tờ khai

    @action
    Scenario: Hủy bỏ việc tạo tờ khai
      Given người nộp thuế đang điền form
      When người nộp thuế hủy bỏ
      Then người nộp thuế quay về danh sách tờ khai
      And không có tờ khai mới được tạo

    @action
    Scenario: Nộp tờ khai hợp lệ
      Given người nộp thuế đã điền đầy đủ thông tin hợp lệ
      When người nộp thuế nộp tờ khai cho cơ quan thuế
      Then tờ khai được tạo thành công

    @action
    Scenario: Hiển thị thông báo sau khi nộp
      Given người nộp thuế đã nộp tờ khai thành công
      Then người nộp thuế thấy thông báo thành công
      And người nộp thuế được chuyển về danh sách

  Rule: Trạng thái tờ khai

    @status
    Scenario Outline: Tờ khai có các trạng thái trong vòng đời
      Given tờ khai đã được tạo
      Then tờ khai có thể ở trạng thái <status>

      Examples:
        | status              |
        | Đã gửi CQT          |
        | Chờ CQT duyệt       |
        | CQT chấp nhận       |
        | CQT không tiếp nhận |
        | Gửi lỗi             |

    @status-transition
    Scenario: Chuyển sang "Chờ CQT duyệt" khi gửi thành công
      Given tờ khai ở trạng thái "Đã gửi CQT"
      When cơ quan thuế tiếp nhận tờ khai
      Then tờ khai chuyển sang "Chờ CQT duyệt"

    @status-transition
    Scenario: Chuyển sang "CQT chấp nhận" khi được duyệt
      Given tờ khai ở trạng thái "Chờ CQT duyệt"
      When cơ quan thuế chấp nhận tờ khai
      Then tờ khai chuyển sang "CQT chấp nhận"

    @status-transition
    Scenario: Chuyển sang "CQT không tiếp nhận" khi bị từ chối
      Given tờ khai ở trạng thái "Chờ CQT duyệt"
      When cơ quan thuế từ chối tờ khai
      Then tờ khai chuyển sang "CQT không tiếp nhận"

    @status-transition
    Scenario: Chuyển sang "Gửi lỗi" khi có lỗi hệ thống
      Given tờ khai ở trạng thái "Đã gửi CQT"
      When có lỗi trong quá trình gửi
      Then tờ khai chuyển sang "Gửi lỗi"

  Rule: Xem và quản lý danh sách tờ khai

    @list-view
    Scenario: Truy cập danh sách tờ khai
      When người nộp thuế chọn menu đăng ký chứng từ điện tử
      Then hệ thống hiển thị danh sách tờ khai

    @list-view
    Scenario: Hiển thị thông tin cơ bản của mỗi tờ khai
      Given người nộp thuế đang xem danh sách
      Then mỗi tờ khai hiển thị thông tin
        | Mã tờ khai        |
        | Ngày lập          |
        | Hình thức         |
        | Loại chứng từ     |
        | Trạng thái        |
        | Ngày chấp nhận    |

    @detail-view
    Scenario: Xem chi tiết tờ khai
      Given người nộp thuế đang xem danh sách
      When người nộp thuế chọn một tờ khai
      Then hệ thống hiển thị đầy đủ thông tin tờ khai

  Rule: Hành động theo trạng thái

    @actions
    Scenario Outline: Hiển thị hành động tương ứng với trạng thái
      Given người nộp thuế đang xem chi tiết tờ khai
      And tờ khai có trạng thái <status>
      Then hệ thống hiển thị hành động <actions>

      Examples:
        | status              | actions                         |
        | Chờ CQT duyệt       | Đóng                            |
        | CQT chấp nhận       | Đóng                            |
        | CQT không tiếp nhận | Đóng, Lập tờ khai mới           |
        | Gửi lỗi             | Đóng, Nộp lại                   |

  Rule: Ghi nhận lịch sử

    @audit
    Scenario: Ghi log khi đăng ký mới
      Given người nộp thuế đã tạo tờ khai đăng ký mới
      Then hệ thống ghi log hành động "Đăng ký mới sử dụng chứng từ điện tử"

    @audit
    Scenario: Ghi log khi thay đổi thông tin
      Given người nộp thuế đã tạo tờ khai thay đổi thông tin
      Then hệ thống ghi log hành động "Thay đổi thông tin đăng ký sử dụng chứng từ điện tử"

  Rule: Hiệu năng hệ thống

    @performance
    Scenario: Form tải nhanh
      When người nộp thuế mở form đăng ký
      Then form hiển thị trong vòng 2 giây

    @performance
    Scenario: Tự động điền dữ liệu nhanh
      When người nộp thuế mở form đăng ký
      Then thông tin được điền tự động trong vòng 1 giây

    @performance
    Scenario: Xử lý timeout khi gửi
      Given người nộp thuế đang gửi tờ khai
      When quá trình gửi vượt quá 30 giây
      Then hệ thống báo timeout

  Rule: Bảo mật

    @security
    Scenario: Kiểm tra quyền truy cập
      Given người dùng không có quyền
      When người dùng cố truy cập chức năng đăng ký
      Then hệ thống từ chối truy cập

    @security
    Scenario: Xác thực chữ ký số
      Given người nộp thuế thêm chữ ký số
      Then hệ thống xác thực tính hợp lệ của chữ ký

    @security
    Scenario: Mã hóa dữ liệu truyền tải
      Given người nộp thuế gửi tờ khai
      When dữ liệu được truyền đến cơ quan thuế
      Then dữ liệu được mã hóa

  Rule: Trải nghiệm người dùng

    @usability
    Scenario: Hiển thị gợi ý cho trường phức tạp
      Given người nộp thuế đang điền form
      When người nộp thuế di chuột qua trường phức tạp
      Then hệ thống hiển thị gợi ý

    @usability
    Scenario: Thông báo lỗi rõ ràng và ngay lập tức
      Given người nộp thuế đang điền form
      When người nộp thuế nhập dữ liệu không hợp lệ
      Then hệ thống hiển thị lỗi ngay lập tức

    @usability
    Scenario: Giao diện thích ứng với thiết bị
      Given người nộp thuế sử dụng thiết bị di động
      When người nộp thuế mở form đăng ký
      Then giao diện tự động điều chỉnh phù hợp
