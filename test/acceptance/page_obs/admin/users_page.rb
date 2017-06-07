require "acceptance/page_obs/admin/admin_page"

class Admin::UsersPage < Admin::AdminPage
  ATTRIBUTES = %i[username name admin allow_auto_login login_locked login_attempts].freeze

  def has_user_table_header?
    # Verify number of TH vs. attributes
    css = 'table.users thead th'
    unless page.has_css?(css, count: ATTRIBUTES.size + 1) # include last empty 'action' header col
      raise "Expected #{ATTRIBUTES.size} columns, but found #{page.all(css).size}"
    end

    # Verify attributes vs. TH values
    ATTRIBUTES.each_with_index do |attr, idx|
      unless page.has_css?("#{css}:nth-of-type(#{idx + 1})", text: attr)
        text = page.all(css)[idx].text
        raise "Expected col[#{idx}] = '#{attr}', but got '#{text}'."
      end
    end
    true
  end

  def has_user_row_attributes?(user, row_idx)
    # Verify number of TD vs. attributes
    css = css_users_row_by_idx row_idx
    unless page.has_css?(css, count: ATTRIBUTES.size + 1)
      raise "Expected user row #{row_idx} to have #{ATTRIBUTES.size} columns, but found #{page.all(css).size}"
    end

    # Verify attribute values vs. TD values
    ATTRIBUTES.each_with_index do |attr, idx|
      td_css = "#{css}:nth-of-type(#{idx + 1})"
      unless page.has_css?(td_css, text: user[attr])
        text = page.find(td_css).text
        raise "Expected row #{row_idx} td[#{idx}] = #{user[attr]}, but got #{text}"
      end

      # Verify actions for each column
      actions_css = "#{css}:nth-of-type(#{ATTRIBUTES.size + 1}) a.btn"
      %w(view edit delete).each_with_index do |action, aIdx|
        unless page.has_css?("#{actions_css}:nth-of-type(#{aIdx + 1})", text: action.capitalize)
          raise "Expected to find action '#{action.capitalize}' in button #{aIdx}, but did not."
        end
      end
    end
    true
  end

  def has_no_user_row_by_id(id)
    page.has_no_css? css_users_row_by_id(id)
  end

  def has_users_count?(count)
    page.has_css?('table.users tbody tr', count: count)
  end

  def click_new_user
    page.find('.btn', text: 'New User').click
  end

  def has_errors?(main_error, detail_errors = nil)
    # Verify main error message
    unless page.has_css?('#error-msg', text: main_error)
      raise "Expected to find main error message, but did not: '#{main_error}'"
    end
    return true unless detail_errors.present?

    # Verify message details
    unless page.has_css?('#error-msg li', count: detail_errors.size)
      raise "Expected to find #{detail_errors.size} error details, but found #{page.all("#error-msg li").size}."
    end
    detail_errors.each_with_index do |err, idx|
      css = "#error-msg li:nth-of-type(#{idx + 1})"
      unless page.has_css?(css, text: err)
        raise "Expected to error[#{idx}] to be '#{err}', but found: '#{page.find(css).text}'"
      end
    end
    true
  end

  def send_key_return
    super "##{input_id(:username)}"
  end

  def has_input_error?(type, err)
    unless page.has_css?("#{css_form_group(type)}.has-error.has-feedback .validation-error", text: err)
      raise "Expected to find field #{type} error message, but did not: /"#{err}/""
    end
    true
  end

  def has_no_input_error?(id)
    css = "#{css_form_group(id)}.has-error"
    unless page.has_no_css?(css) || page.has_no_css?("#{css} .validation-error")
      raise "Expected to not find field #{id} error message, but did."
    end
    true
  end

  def fill_in(id, val)
    page.fill_in(id: input_id(id), with: val)
  end

  def has_field?(id, val, disabled = false)
    page.has_field?({id: input_id(id), disabled: disabled}, with: val)
  end

  def click_save
    page.find("input[type=submit][value='Save']").click
  end

  def click_cancel
    page.find('.btn', text: 'Cancel').click
  end

  def has_no_save_btn?
    page.has_no_css?("input[type=submit][value='Save']")
  end

  def click_back_to_users
    page.find('.btn', text: 'Back to Users').click
  end

  def has_cancel_btn?
    page.has_css?('.btn', text: 'Cancel')
  end

  def click_user_action(id, action) # :view, :edit, :delete
    css = "#{css_users_row_by_id(id)} a.btn"
    page.find(css, text: action.to_s.capitalize).click
  end

  def has_checked_field?(id, disabled = false)
    page.has_checked_field?({id: input_id(id)}, {disabled: disabled})
  end

  def has_no_checked_field?(id, disabled = false)
    page.has_no_checked_field?({id: input_id(id)}, {disabled: disabled})
  end

  def click_log_out
    page.find('#log-out').click
  end

  def check(id)
    page.check id: input_id(id)
  end

  def uncheck(id)
    page.uncheck id: input_id(id)
  end

  def has_demo_mode_flash?
    page.has_css?('.alert-warning', text: Admin::UsersController::DEMO_MSG)
  end

  def has_no_demo_mode_flash?
    page.has_no_css?('.alert-warning', text: Admin::UsersController::DEMO_MSG)
  end

  def has_help_block_content?(id, content)
    page.find("##{id.to_s.dasherize} .help-block").has_content? content
  end

  private

  def input_id(id) # :username, :password, :name, :login_locked
    "user_#{id}"
  end

  def css_form_group(id)
    "#user_form_group_#{id}"
  end

  def css_users_row_by_idx(row_idx)
    "table.users tbody tr:nth-of-type(#{row_idx + 1}) td"
  end

  def css_users_row_by_id(id)
    "table.users tbody tr[data-id='#{id}'] td"
  end
end
