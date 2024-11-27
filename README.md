# 简单包装后的阿里开源低代码前端实现方式

> [lowcode-demo](https://github.com/alibaba/lowcode-demo)
>
> [lowcode-engine](https://github.com/alibaba/lowcode-engine)

bug：如果添加面包片之后，后台报错缺少什么内容的话，需要去projectSchema.txt中删掉包含那个内容的那一层级。（具体是啥忘记嘞）

使用 `docker-compose up -d --force-recreate --build` 拉起容器，拉起前需要确认是否修改了 docker-compose.yaml 中的 volumes 的内容
