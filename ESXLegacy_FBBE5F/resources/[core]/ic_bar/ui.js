$(document).ready(function() {

    window.addEventListener('message', function(event) {

        var data = event.data;

        var $box = $("#box");

        var $boxArmor = $("#boxArmor");

        var $boxStamina = $("#boxStamina");

        var $boxVoice = $("#boxVoice");



        $box.css("width", (event.data.heal-100)+"%");

        $boxArmor.css("width", (event.data.armor)+"%");

        $boxStamina.css("width", (event.data.stamina)+"%");

        $boxVoice.css("width", (event.data.voice)+"%");

        $(".container").css("display",data.show? "none":"block");

        if (event.data.action == "updateStatus") {

            updateStatus(event.data.st);

        }

        if (event.data.talking == true) {

            $boxVoice.css("background", "rgba(255, 55, 155, 170)")

        }

        else if (event.data.talking == false) {

            $boxVoice.css("background", "#a19ea0")

        }

    })

})



function updateStatus(status){

    $('#boxHunger').css('width', status[0].percent+'%')

    $('#boxThirst').css('width', status[1].percent+'%')

    $('#boxDrunk').css('width', status[2].percent+'%')

}