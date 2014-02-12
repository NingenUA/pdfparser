class PdfParserWorker
  include Sidekiq::Worker
  require 'pdf/reader'

  def perform(file)
    read_pdf(file)
  end
  def group_summary(page)

    totals = page.text.scan(/.C .+/)
    totals.each do |tot|
      ts=tot.split(" ")
      group=Group.new( :user =>ts[1].to_s, :servpp => ts[2].to_s,
                       :ala => ts[3].to_s, :ldarc => ts[4].to_s,
                       :dvao => ts[5].to_s,:otherf => ts[9].to_s,
                       :gst => ts[12].to_s,:subtotal=> ts[11].to_s,
                       :total => ts[13].to_s , :book_id => @id )
      group.save
    end
  end
 def page_text_scan(page,txt,i=1)
    pscan = page.text.scan(/.Total.+[\d]{1,3}.[\d]{2}/)
    if page.text.scan(txt).empty?
      return ""
    else
      @i+=i
      return pscan[@i].split("$ ")[1].to_s


    end
  end

  def individual_detail(page)
    client_number = page.text.scan(/.[\d]{3}-[\d]{3}-[\d]{4}/)[0].to_s
    client_name = page.text.scan(/\w{3,}\s\w{3,}$/)[0].to_s
    pscan = page.text.scan(/.Total.+[\d]{1,3}.[\d]{2}/)

    @i = -1



    individ=Individual.new(:client_number => client_number, :client_name => client_name ,
                           :tms => page_text_scan(page,"Total Month's Savings"),
                           :spn =>page_text_scan(page,"Service Plan Name") ,
                           :ala => page_text_scan(page,"Additional Local Airtime"),
                           :ldc => page_text_scan(page,"Long Distance Charges"),
                           :daos => page_text_scan(page,"Data and Other Serv"),
                           :vas => page_text_scan(page,"Value Added Service"),
                           :total => page_text_scan(page,"Total Current",2),
                           :book_id => @id )
    individ.save
  end
  
  def book_elm(doc,elem)
    doc.page(1).text.scan(elem)[0].split(" : ")[1].to_s
  end
  
  def read_pdf(file)

    a=0
    doc = PDF::Reader.new(file)
    book = Book.new(:client_num => book_elm(doc,/.CLIE.+/) , :bill_num  => book_elm(doc,/.BILL.+/))
    book.save
    doc.pages.each do |page|
      unless (page.text.scan(/.G R O U P S U M M A R Y - U S E R T O T .+/).empty?)
         group_summary(page)
      end
      unless (page.text.scan(/I N D I V I D U A L D E T A I L$/).empty?)
        a+=1
        if a<6
          individual_detail(page)
        else
          $redis.publish('book_created',"finish")
          return


        end
      end

    end
  end
end
