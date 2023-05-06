resource "aws_key_pair" "dove-key" {
  key_name   = "dove-key"
  public_key = file("yasser.pub")

}

resource "aws_instance" "dove-app" {
  ami                    = var.AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.dove-pub-1.id
  key_name               = aws_key_pair.dove-key.key_name
  vpc_security_group_ids = [aws_security_group.dove_stack_sg.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = var.USER
    private_key = file(var.PRIVATE_KEY)
  }

  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }

  provisioner "remote-exec" {

    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }



  tags = {
    Name = "my-dove"
  }

}
resource "aws_ebs_volume" "vol_4_dove" {
  availability_zone = var.ZONE1
  size              = 3
  tags = {
    Name = "extra-vol-4-dove"
  }

}
resource "aws_volume_attachment" "attach_vol_dove" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.vol_4_dove.id
  instance_id = aws_instance.dove-app.id

}

output "Public-ip" {
  value = aws_instance.dove-app.public_ip
}