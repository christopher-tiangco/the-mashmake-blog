module ApplicationHelper
    
    def gravatar_for(email, options = {size: 80})
        email_address = email.downcase
        hash = Digest::MD5.hexdigest(email_address)
        image_src = "https://www.gravatar.com/avatar/#{hash}?s=#{options[:size]}&d=identicon&r=PG" # `d=identicon` used to autogenerate a gravatar icon if none is present for the email
        image_tag(image_src)
    end
    
end
