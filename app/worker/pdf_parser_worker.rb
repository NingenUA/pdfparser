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
      group.save
    end
  end

  def individual_detail(page)
    client_number = page.text.scan(/.[\d]{3}-[\d]{3}-[\d]{4}/)[0].to_s
    client_name = page.text.scan(/\w{3,}\s\w{3,}$/)[0].to_s
    pscan = page.text.scan(/.Total.+[\d]{1,3}.[\d]{2}/)
    i = 0


    unless page.text.scan("Total Month's Savings").empty?

      itms = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      itms = ""
    end
    unless page.text.scan("Service Plan Name").empty?
      ispn = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      ispn = ""
    end
    unless page.text.scan("Additional Local Airtime").empty?
      iala = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      iala = ""
    end
    unless page.text.scan("Long Distance Charges").empty?
      ildc = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      ildc = ""
    end
    unless page.text.scan("Data and Other Serv").empty?
      idaos = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      idaos = ""
    end
    unless page.text.scan("Value Added Service").empty?
      ivas = pscan[i].split("$ ")[1].to_s
      i+=1
    else
      ivas = ""
    end
    unless page.text.scan("Total Current ").empty?
      i+=1
      itotal = pscan[i].split("$ ")[1].to_s
    else
      itotal = ""
    end
    individ=Individual.new(:client_number => client_number, :client_name => client_name ,
                           :tms =>itms, :spn => ispn, :ala => iala, :ldc => ildc,
                           :daos => idaos,:vas => ivas,:total => itotal,
                           :book_id => @id )
    individ.save
  end
  def read_pdf(file)

    a=0
    doc = PDF::Reader.new(file)

    @client=doc.page(1).text.scan(/.CLIE.+/)[0].split(" : ")[1].to_s
    bill = doc.page(1).text.scan(/.BILL.+/)[0].split(" : ")[1].to_s
    book = Book.new(:client_num => @client , :bill_num  => bill)
    book.save

    @id = book.id
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