resource "aws_instance" "this" {
  count = var.instance_count

  ami              = var.ami
  instance_type    = var.instance_type
  subnet_id = element(
    distinct(compact(var.subnet_ids)),
    count.index,
  )
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids

  associate_public_ip_address = var.associate_public_ip_address

  tags = merge(
    {
      "Name" = var.instance_count > 1 ? format("%s-%d", var.name, count.index + 1) : var.name
    },
    var.tags,
  )
}