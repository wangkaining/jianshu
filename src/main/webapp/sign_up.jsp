<%--
    Created by mingfei.net@gmail.com
    6/27/17 10:47
    https://github.com/thu/jianshu/
--%>
<!DOCTYPE html>
<%@ page contentType='text/html;charset=UTF-8' language='java' %>
<html>
<head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>注册 - 简书</title>
    <link rel='shortcut icon' type='image/x-icon' href='favicon.ico'>
    <link rel='stylesheet' href='static/css/bootstrap.min.css'>
    <link rel='stylesheet' href='static/css/bootstrap-switch.min.css'>
    <style>
        @import 'static/css/nav.css';
    </style>
    <style>
        body {
            background: #f1f1f1;
        }

        #logo {
            margin-bottom: 15px;
        }

        h3 a {
            display: inline-block;
            margin: 30px 10px;
        }

        #sign-up {
            color: #ea6f5a;
        }

        #form-box {
            border-radius: 5px;
            box-shadow: 1px 1px 1px #0f0f0f;
        }

        #form-box {
            background: #fff;
            padding: 50px;
        }

        #form-box div {
            margin-top: 15px;
        }

        #form-box button {
            margin: 30px 0 15px;
        }

        #nick-message,
        #mobile-message,
        #password-message {
            display: none;
        }
    </style>
    <script src='static/js/jquery.min.js'></script>
    <script src='static/js/bootstrap.min.js'></script>
    <script src='static/js/bootstrap-switch.min.js'></script>
    <script src='static/js/nav.js'></script>
    <script>

        var isNickValidated; // 昵称通过了验证
        var isMobileValidated; // 手机号通过了验证

        function showMessage(element, text, removedClass, addedClass) {
            element.parent()
                .removeClass(removedClass[0])
                .addClass(addedClass[0]);
            element.parent().next('small')
                .text(text)
                .removeClass(removedClass[1])
                .addClass(addedClass[1])
                .fadeIn('slow');
        }

        function validate(aysnc) {
            var nick = $('#nick');
            if (nick.val().trim().length === 0) {
                showMessage(
                    nick,
                    '请输入昵称',
                    ['has-success', 'text-success'],
                    ['has-error', 'text-danger']
                );
                nick.focus();
                isNickValidated = false;
                return;
            }
            $.ajax({
                url: 'user',
                type: 'post',
                data: {'action': 'isNickExisted', 'nick': nick.val()},
                dataType: 'json',
                async: aysnc,
                success: function (result) {
                    var isNickExisted = result.isNickExisted; // false
                    console.log("isNickExisted: " + isNickExisted);

                    if (isNickExisted) {
                        showMessage(
                            nick,
                            '昵称 已经被使用',
                            ['has-success', 'text-success'],
                            ['has-error', 'text-danger']
                        );
                         isNickExisted = false;
                    } else {
                        showMessage(
                            nick,
                            '昵称 可以使用',
                            ['has-error', 'text-danger'],
                            ['has-success', 'text-success']
                        );
                        isNickValidated = true;
                    }
                }
            });
        }

        $(function () {
            $('#index').removeClass('active');

            $('#nick').blur(function () {
                validate(true);
            });

            $('#sign-up-form').submit(function () {
                validate(false);
                return isNickValidated && isMobileValidated;
                if (!isNickValidated) {
                    $('#nick').focus();
                } else {
                    $('#mobile').focus();
                }
            });
        });
    </script>
</head>
<body>
<%@ include file='nav.jsp' %>
<div class='container'>
    <div id='logo'><img src='static/image/logo.png' alt='简书'></div>
    <div id='form-box' class='col-md-4 col-md-offset-4'>
        <h3 class='text-center'><a class='text-muted' href=''>登录</a> · <a id='sign-up' href=''>注册</a></h3>
        <form id="sign-up-form" class='form-horizontal' action='user' method='post'>
            <input type='hidden' name='action' value='signUp'>
            <div class='input-group'>
                <span class='input-group-addon'><i class='glyphicon glyphicon-user'></i></span>
                <input id='nick' name='nick' class='form-control input-lg' type='text' placeholder='你的昵称'>
            </div>
            <small id='nick-message'></small>
            <div class='input-group'>
                <span class='input-group-addon'><i class='glyphicon glyphicon-phone'></i></span>
                <input name='mobile' class='form-control input-lg' type='text' placeholder='手机号'>
            </div>
            <small id='mobile-message'></small>
            <div class='input-group'>
                <span class='input-group-addon'><i class='glyphicon glyphicon-lock'></i></span>
                <input name='password' class='form-control input-lg' type='password' placeholder='设置密码'>
            </div>
            <small id='password-message'></small>
            <button class='btn btn-success btn-lg btn-block'>注册</button>
            <p class='text-center'>
                <small>点击 “注册” 即表示您同意并愿意遵守简书</small>
            </p>
            <p class='text-center'>
                <small><a href=''>用户协议</a> 和 <a href=''>隐私政策</a> 。</small>
            </p>
        </form>
        <small class="text-danger">${requestScope.message}</small>
    </div>
</div>
</body>
</html>
