<ul class="post-list">
{{range .Data.writing.pages}}
<li class="post-link">
<span class="date">{{.formatteddate}}</span><a href="{{print  "/writing/" .slug}}"><span>{{.title}}</span></a></li>
{{end}}
</ul>
