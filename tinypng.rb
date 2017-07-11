=begin
 https://tinypng.com/developers/reference/ruby
 调用tinypng的API对png和jpg格式的图片进行批量压缩
 将TINIFYKEY换成自己申请的key
 使用时需要指定要压缩的文件夹
 ruby tinypng.rb images
 压缩后会直接覆盖原有的图片，压缩前请自行备份原图
 压缩失败的图片会保存在ARGV[0]_Failure文件夹下
=end

require 'fileutils'
require 'tinify'

#tinyPNG的key,https://tinypng.com/developers
TINIFYKEY = ""
Tinify.key = TINIFYKEY

TINIPNGFAILPATH = `pwd`.chomp + "/" + ARGV[0] + "_Failure/"

#创建一个保存压缩失败图片的文件夹
def createFilurePath
    if !File.directory? TINIPNGFAILPATH
        Dir.mkdir TINIPNGFAILPATH
    end
end

#调用tinypng的API进行图片压缩
def tinify(imgPath, imgName)
    puts "#{imgName}开始压缩"
    
    begin
       source = Tinify.from_file imgPath
       source.to_file imgPath
    rescue
        createFilurePath
        p = `pwd`.chomp + "/" + imgPath
        copyP = TINIPNGFAILPATH + imgName
        FileUtils.cp p, copyP
        puts "#{imgName}压缩失败 #{$!}"
    end
end

def tinifyImage(path)
    Dir.foreach path do |entry|
        if entry == "." || entry == ".." || entry == ".DS_Store" #如果是这三个文件直接跳过
            next
        end
        
        p = "#{path}/#{entry}" #文件的路径
        if File.file? p
            if (p.end_with? ".png") || (p.end_with? ".jpg") #tinify只能压缩png和jpg格式的图片
                tinify p, entry
            end
        end
    end
end

if ARGV[0]
    tinifyImage ARGV[0]
else
    puts "请指定文件夹"
end
