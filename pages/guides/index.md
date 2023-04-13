<ul class="post-list">
{{range .Data.guides.pages}}
<li class="post-link">
<span class="date">{{.formatteddate}}</span><a href="{{print  "/guides/" .slug}}"><span>{{.title}}</span></a></li>
{{end}}
</ul>
