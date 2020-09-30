class PagasMailer < ApplicationMailer
	def paga_specific_email
		@date_from = Date.parse(params[:date_from]) rescue ""
    @date_to = Date.parse(params[:date_to]) rescue ""
    @user = User.find(params[:user].id)
    @current_admin = params[:current_admin]
    if @user.works.count != 0 
      @works = @user.works.sort_by { |w| [w.start]}
      @groups = @user.groups.select { |w| w.works.count != 0}.sort_by { |w| [w.works.first.start]}
      @total = 0
      @extra_t_para = 0
      @missing_t = 0
      @missing_t_para = 0
      @extra_pushim_t_para = 0
      @extra_t = 0
      @extra_pushim_t = 0
      @sales ||= 0
      users_month(@user, @date_from, @date_to)
      @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
      @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
      @extra_t = @extra_t_para
      @extra_pushim_t = @extra_pushim_t_para
      @missing_t = @missing_t_para
      @total = @total - (@extra_t + @extra_pushim_t)
      if @extra_t_para >= @missing_t
        @extra_t = @extra_t_para - @missing_t
      elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
        @missing_t -= @extra_t_para
        @extra_t = 0
        @extra_pushim_t = @extra_pushim_t_para - @missing_t
      else
        @extra_t = 0
        @extra_pushim_t = 0
        if @missing_t > @total
          @total = 0
        else
          @total = @total - @missing_t
        end
      end
      @ora = @user.ora
      @ora_e = @user.ora_e
      @ora_p = @user.ora_p
      @salary = (@total * @ora/60) 
      @sales = @user.sales 
      @sig = @salary * 0.05
      @salary_ps = @salary - @sig
      if @user.salary_type == "Primare"
        if @salary_ps>450
          @tatimi = (@salary_ps-450)*0.1+22.8
        elsif @salary_ps>250
          @tatimi = (@salary_ps-250)*0.08+6.8
        elsif @salary_ps>80
          @tatimi = (@salary_ps-80)*0.04
        else
          @tatimi = 0
        end
      else
        @tatimi = @salary * 0.1
      end
      @salary_neto = @salary - (@sig + @tatimi)
      @oret_e = @extra_t * @ora_e/60
      @oret_p = @extra_pushim_t * @ora_p/60
      @oret_e_kohe = @extra_t * 1.3
      @oret_p_kohe = @extra_pushim_t * 1.5
      @salary_e = @salary + @oret_e + @oret_p + @sales
      @sig_e = @salary_e * 0.05
      @salary_ps_e = @salary_e - @sig_e
      if @user.salary_type == "Primare"
        if @salary_ps_e>450
          @tatimi_e = (@salary_ps_e-450)*0.1+22.8
        elsif @salary_ps_e>250
          @tatimi_e = (@salary_ps_e-250)*0.08+6.8
        elsif @salary_ps_e>80
          @tatimi_e = (@salary_ps_e-80)*0.04
        else
          @tatimi_e = 0
        end
      else
        @tatimi_e = @salary_e * 0.1
      end
      @sig_e = @salary_e * 0.05 
      @salary_ps_e = @salary_e - @sig_e
      @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
      @extra_payment ||= @salary_e_n - @salary_neto
    else
	  	return
	  end

    attachments["Pagesa mujore per #{@user.name} - #{@date_from}/ #{@date_to}.pdf"] = WickedPdf.new.pdf_from_string(
	      render_to_string(pdf: 'pdf', template: 'users/pdf.pdf.erb', layout: 'pdf.pdf.erb')
	    )
    if @current_admin.sending_mail == "humanresources@albinadyla.com"
        mail(:to => @user.email,
           :subject => "Pagesa mujore për periudhën #{@date_from} - #{@date_to}",
           delivery_method_options: { user_name: "humanresources@albinadyla.com",
                         password: "qtjkkzsrhkjnsdly",
                         address: "smtp.gmail.com" })
      elsif @current_admin.sending_mail == "humanresources.pr@albinadyla.com"
        mail(:to => @user.email,
           :subject => "Pagesa mujore për periudhën #{@date_from} - #{@date_to}",
           delivery_method_options: { user_name: "humanresources.pr@albinadyla.com",
                         password: "mqekbmclvezuzjks",
                         address: "smtp.gmail.com" })
      end
  end

	def paga_email
		@date_from = Date.parse(params[:date_from]) rescue ""
    @date_to = Date.parse(params[:date_to]) rescue ""
    @user = User.find(params[:user].id)
    @current_admin = params[:current_admin]
    @specific = params[:specific]
    if @user.works.count != 0 
      @works = @user.works.sort_by { |w| [w.start]}
      @groups = @user.groups.select { |w| w.works.count != 0}.sort_by { |w| [w.works.first.start]}
      @total = 0
      @extra_t_para = 0
      @missing_t = 0
      @missing_t_para = 0
      @extra_pushim_t_para = 0
      @extra_t = 0
      @extra_pushim_t = 0
      @sales ||= 0
      users_month(@user, @date_from, @date_to)
      @works.each { |w| next if w.part_group; @total += w.total; @extra_t_para += w.extra; @missing_t_para += w.missing; @extra_pushim_t_para += w.extra_pushim}
      @groups.each { |g| @total += g.total; @extra_t_para += g.extra; @missing_t_para += g.missing; @extra_pushim_t_para += g.extra_pushim}
      @extra_t = @extra_t_para
      @extra_pushim_t = @extra_pushim_t_para
      @missing_t = @missing_t_para
      if @extra_t_para >= @missing_t
        @extra_t = @extra_t_para - @missing_t
      elsif (@extra_pushim_t_para + @extra_t_para) >= @missing_t
        @missing_t -= @extra_t_para
        @extra_t = 0
        @extra_pushim_t = @extra_pushim_t_para - @missing_t
      else
        @extra_t = 0
        @extra_pushim_t = 0
      end
      @salary = @user.salary
      @sales = @user.sales 
      @sig = @salary * 0.05
      @salary_ps = @salary - @sig
      if @user.salary_type == "Primare"
        if @salary_ps>450
          @tatimi = (@salary_ps-450)*0.1+22.8
        elsif @salary_ps>250
          @tatimi = (@salary_ps-250)*0.08+6.8
        elsif @salary_ps>80
          @tatimi = (@salary_ps-80)*0.04
        else
          0
        end
      else
        @tatimi = @salary * 0.1
      end
      @salary_neto = @salary - (@sig + @tatimi)
      @ora = @user.ora
      @ora_e = @user.ora_e
      @ora_p = @user.ora_p
      @oret_e = @extra_t * @ora_e/60
      @oret_p = @extra_pushim_t * @ora_p/60
      @oret_e_kohe = @extra_t * 1.3
      @oret_p_kohe = @extra_pushim_t * 1.5
      @salary_e = @salary + @oret_e + @oret_p + @sales
      @sig_e = @salary_e * 0.05
      @salary_ps_e = @salary_e - @sig_e
      if @user.salary_type == "Primare"
        if @salary_ps_e>450
          @tatimi_e = (@salary_ps_e-450)*0.1+22.8
        elsif @salary_ps_e>250
          @tatimi_e = (@salary_ps_e-250)*0.08+6.8
        elsif @salary_ps_e>80
          @tatimi_e = (@salary_ps_e-80)*0.04
        else
          0
        end
      else
        @tatimi_e = @salary_e * 0.1
      end
      @salary_e_n = @salary_e - (@sig_e + @tatimi_e)
      @extra_payment ||= @salary_e_n - @salary_neto
	  else
	  	return
	  end
  	 attachments["Pagesa mujore për periudhën #{@date_from} - #{@date_to}.pdf"] = WickedPdf.new.pdf_from_string(
        render_to_string(pdf: 'pdf', template: 'users/pdf.pdf.erb', layout: 'pdf.pdf.erb')
      )
      if @current_admin.sending_mail == "humanresources@albinadyla.com"
        mail(:to => @user.email,
	         :subject => "Pagesa mujore për periudhën #{@date_from} - #{@date_to}",
           delivery_method_options: { user_name: "humanresources@albinadyla.com",
                         password: "qtjkkzsrhkjnsdly",
                         address: "smtp.gmail.com" })
      elsif @current_admin.sending_mail == "humanresources.pr@albinadyla.com"
        mail(:to => @user.email,
           :subject => "Pagesa mujore për periudhën #{@date_from} - #{@date_to}",
           delivery_method_options: { user_name: "humanresources.pr@albinadyla.com",
                         password: "mqekbmclvezuzjks",
                         address: "smtp.gmail.com" })
      end
        
  end
end
#  file = CSV.generate do |csv|
      #   csv << ["ID", "Emri", "Fillimi", "Mbarimi", "Total", "Shtese", "Mungese", "Pushim"]
      #   @works.each do |a|
      #     csv << [a.user.idnum, a.user.name, a.start.strftime("%Y-%m-%d %H:%M"), a.end.strftime("%Y-%m-%d %H:%M"), a.total.to_i, a.extra.to_i, a.missing.to_i, a.extra_pushim.to_i]
      #   end
      #   csv << [""]
      #   csv << ["", "Totali", "", "", "", @extra_t_para.to_i, @missing_t.to_i, @extra_pushim_t_para.to_i]
      #   csv << [""]
      #   csv << ["", "Pasqyra e pagës Bruto për periudhën #{@date_from} - #{@date_to}"]
      #   csv << ["", "Pagesa totale Bruto", @salary]
      #   csv << ["", "Sigurimet Shoqërore punëdhënësi", @sig.round(2)]
      #   csv << ["", "Sigurimet Shoqërore punëmarrësi", @sig.round(2)]
      #   csv << ["", "Paga minus Sigurime Shoqërore nga punëmarrësi (paga e Tatushme)", @salary_ps.round(2)]
      #   csv << ["", "Tatimi mbi Pagë", @tatimi.round(2)]
      #   csv << ["", "Paga Neto (pagesa në llogarinë tuaj bankare)", @salary_neto.round(2)]
      #   csv << [""]
      #   csv << [""]
      #   csv << [""]
      #   csv << ["", "Pasqyra e pagës totale për periudhën #{@date_from} - #{@date_to}"]
      #   csv << ["", "Pagesa totale Bruto", @salary]
      #   csv << ["", "Çmimi për orë normale", @ora.round(2)]
      #   csv << ["", "Çmimi për orë normale", @ora_e.round(2)]
      #   csv << ["", "Orë shtesë me 30%", "#{(@extra_t/60).to_i}:#{@extra_t%60 < 10 ? "0" : ""}#{(@extra_t%60).to_i}"]
      #   csv << ["", "Orë shtesë me 50%", "#{(@extra_pushim_t/60).to_i}:#{@extra_pushim_t%60 < 10 ? "0" : ""}#{(@extra_pushim_t%60).to_i}"]
      #   csv << ["", "Pagesa për orët shtesë me 30%", @oret_e.round(2)]
      #   csv << ["", "Pagesa për orët shtesë me 50%", @oret_p.round(2)]
      #   csv << ["", "Pagesa për perqindjet ne shitje", @user.sales.round(2)]
      #   csv << ["", "Pagesa Bruto Totale (paga+orët shtesë)", @salary_e.round(2)]
      #   csv << ["", "Sigurimet Shoqërore punëdhënësi", @sig_e.round(2)]
      #   csv << ["", "Sigurimet Shoqërore punëmarrësi", @sig_e.round(2)]
      #   csv << ["", "Paga minus Sigurime Shoqërore nga punëmarrësi (paga e Tatushme)" , @salary_ps_e.round(2)]
      #   csv << ["", "Tatimi mbi Pagë", @tatimi_e.round(2)]
      #   csv << [""]
      #   csv << ["", "Paga Neto (pagesa në llogarinë tuaj bankare gjithësej me orë shtesë)", @salary_e_n.round(2)]
      #   csv << [""]
      #   csv << ["", "Pagesa Neto totale për orët shtesë", @extra_payment.round(2)]
      # end
      
      # attachments["Pagesa mujore per #{@user.name}.csv"] = {mime_type: 'text/csv', content: file}