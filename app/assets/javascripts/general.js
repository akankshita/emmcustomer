//jQuery.noConflict();
jQuery(document).ready(function() {
    // Search input text handling on focus
		var jQuerysearchq = jQuery("#search-q").attr("value");
	    jQuery('#search-q.text').css('color', '#999');
		jQuery('#search-q').focus(function(){
			if ( jQuery(this).attr('value') == jQuerysearchq) {
				jQuery(this).css('color', '#555');
				jQuery(this).attr('value', '');
			}
		});
		jQuery('#search-q').blur(function(){
			if ( jQuery(this).attr('value') == '' ) {
				jQuery(this).attr('value', jQuerysearchq);
				jQuery(this).css('color', '#999');
			}
		});
	// Switch categories
		jQuery('#h-wrap').hover(function(){
				jQuery(this).toggleClass('active');
				jQuery("#h-wrap ul").css('display', 'block');
			}, function(){
				jQuery(this).toggleClass('active');
				jQuery("#h-wrap ul").css('display', 'none');
		});
	// Handling with tables (adding first and last classes for borders and adding alternate bgs)
		jQuery('tbody tr:even').addClass('even');
		jQuery('table.grid tbody tr:last-child').addClass('last');
		jQuery('tr th:first-child, tr td:first-child').addClass('first');
		jQuery('tr th:last-child, tr td:last-child').addClass('last');
		jQuery('form.fields fieldset:last-child').addClass('last');
	// Handling with lists (alternate bgs)
		jQuery('ul.simple li:even').addClass('even');
	// Handling with grid views (adding first and last classes for borders and adding alternate bgs)
		jQuery('.grid .line:even').addClass('even');
		jQuery('.grid .line:first-child').addClass('firstline');
		jQuery('.grid .line:last-child').addClass('lastline');
	// Tabs switching
		jQuery('#box1 .content#box1-grid').hide(); // hide content related to inactive tab by default
		jQuery('#box1 .header ul a').click(function(){
			jQuery('#box1 .header ul a').removeClass('active');
			jQuery(this).addClass('active'); // make clicked tab active
			jQuery('#box1 .content').hide(); // hide all content
			jQuery('#box1').find('#' + jQuery(this).attr('rel')).show(); // and show content related to clicked tab
			return false;
		});


});

jQuery(document).ready(function(){
	jQuery("#checkall").click(function()				
	{
		var checked_status = this.checked;
		jQuery('.sel_checkbox').attr('checked', checked_status);
	});					
});

function RedirectURL(url)
{
	window.location = url;
}

function doAsAction(obj)
{
	val = obj.value;
	jQuery('#mode').val(val);
	
	if(val!='')
	{	
		if (val == 'ViewAll')
		{
			jQuery('#frmlist').submit();
		}
		else
		{
			tot = getCheckCount();
			if(tot>0)
			{
				if(val == "Delete"){
					var con=confirm("Are You sure you want to delete selected record?")
					if(con){
						jQuery('#frmlist').submit();
					}else{
						return false;
					}
				}else{
					jQuery('#frmlist').submit();
				}
			}
			else
			{
				alert('Please select any record')
				obj.options[0].selected=true;
			}
			return false;
		}
	}
}

function getCheckCount()
{
	var chkBoxArr = jQuery('input[type="checkbox"]');
  	var tot=0;
  	for(i=0;i<chkBoxArr.length;i++)
  	{
  	  	if(chkBoxArr[i].id == 'iId' && chkBoxArr[i].checked)
		{
			tot++;
		}
  
  	}
    return tot; 
}



function validate_search()
{	
	var keyword = jQuery('#keyword').val();
	var option = jQuery('#option').val();
	if(keyword=='' &&  option=='')
	{
		alert('Please select Field or enter keyword to search records');
		return false;
	}
	else if(keyword !='' &&  option=='')
	{
		alert('Please select Field to search records');
		return false;
	}
	else if(keyword == '' &&  option !='')
	{
		alert('Please enter keyword to search records');
		return false;
	}
        return true;
}

