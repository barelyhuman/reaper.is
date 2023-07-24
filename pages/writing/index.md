# Writing

<ul class="p-0 px-0">
<hr class="h-1 border-light"/>
{{range .Data.writing.pages}}
<li class="flex flex-direction gap-3 items-center justify-between py-4">
<a class="text-gray hover:text-dark" href="{{print  " /writing/" .slug}}">
<div class="inline-block">{{.title}}</div>
</br>
<div class="inline-block" class="date">{{.formatteddate}}</div>
</a>
</li>
{{end}}
</ul>
